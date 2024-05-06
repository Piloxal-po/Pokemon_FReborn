# Pulse Dex class. Based on xLed's Jukebox Scene class.
class Scene_PulseDex
  #-----------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : command cursor's initial position
  #-----------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end

  #-----------------------------------------------------------------------------
  # * Main Processing
  #-----------------------------------------------------------------------------
  def main
    fadein = true
    # Makes the text window
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites["background"] = IconSprite.new(0, 0)
    @sprites["background"].setBitmap("Graphics/Pictures/navbg")
    @sprites["background"].z = 255
    @choices = pbPulseSeen
    @sprites["header"] = Window_UnformattedTextPokemon.newWithSize(_INTL("Pulse Dex"), 2, -18, 128, 64, @viewport)
    @sprites["header"].baseColor = Color.new(248, 248, 248)
    @sprites["header"].shadowColor = Color.new(0, 0, 0)
    @sprites["header"].windowskin = nil
    @sprites["command_window"] = Window_CommandPokemonWhiteArrow.new(@choices, 324)
    @sprites["command_window"].windowskin = nil
    @sprites["command_window"].baseColor = Color.new(248, 248, 248)
    @sprites["command_window"].shadowColor = Color.new(0, 0, 0)
    @sprites["command_window"].index = @menu_index
    @sprites["command_window"].setHW_XYZ(282, 324, 94, 46, 256)
    tts(@choices[@menu_index])
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepares for transition
    Graphics.freeze
    # Disposes the windows
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  #-----------------------------------------------------------------------------
  # * Frame Update
  #-----------------------------------------------------------------------------  #-----------------------------------------------------------------------------
  def update
    pbUpdateSpriteHash(@sprites)
    if Input.repeat?(Input::UP) || Input.repeat?(Input::L) || Input.repeat?(Input::DOWN) || Input.repeat?(Input::R)
      tts(@choices[@sprites["command_window"].index])
    end
    # update command window and the info if it's active
    if @sprites["command_window"].active
      update_command
      return
    end
  end

  #-----------------------------------------------------------------------------
  # * Command controls
  #-----------------------------------------------------------------------------
  def update_command
    index = @sprites["command_window"].index
    # If B button was pressed
    if Input.trigger?(Input::B) || (Input.trigger?(Input::C) && index == @choices.length - 1)
      # Switch to map screen
      pbPlayCancelSE()
      $scene = Scene_Pokegear.new
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C) && $game_switches[getPulseInfo[index][0]]
      pbPlayDecisionSE()
      $scene = Scene_PulseDex_Info.new("Graphics/Pictures/#{getPulseInfo[index][1]}", index)
      return
    end
  end

  #-----------------------------------------------------------------------------
  # * Determines which Pulses the trainer has data for
  #-----------------------------------------------------------------------------
  def pbPulseSeen
    pulseSeen = []
    for i in getPulseInfo
      pulseSeen.push($game_switches[i[0]] ? i[2] : "???")
    end
    pulseSeen.push("Back")
    return pulseSeen
  end
end

def preparePulseDexInfo(backgrounds)
  sprites = {}
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  sprites["background"] = IconSprite.new(0, 0, viewport)
  if backgrounds.is_a?(Array)
    sprites["background"].setBitmap("Graphics/Pictures/#{getPulseInfo[backgrounds[0]][1]}")
  else
    sprites["background"].setBitmap(backgrounds)
  end
  sprites["background"].z = 255
  return viewport, sprites
end

def ttsPulse(index)
  entry = getPulseInfo[index][2]
  species = getPulseInfo[index][3]
  form = getPulseInfo[index][4]
  note = getPulseInfo[index][5]
  type1 = $cache.pkmn[species, form].Type1
  type2 = $cache.pkmn[species, form].Type2
  ability = $cache.pkmn[species, form].Abilities[0]
  basestats = $cache.pkmn[species, form].BaseStats.clone
  for i in 0...basestats.length
    basestats[i] = (basestats[i] / 255.0 * 100).round(0)
    basestats[i] = 1 if basestats[i] == 0
  end
  text = "PULSE #{entry}. #{type1}#{type2 ? " and #{type2}" : ""} type. #{ability} ability. #{note} "
  text += ", HP, #{basestats[0]} %. Attack, #{basestats[1]} %. Defense, #{basestats[2]} %. Special Attack, #{basestats[3]} %. Special Defense, #{basestats[4]} %. Speed, #{basestats[5]} %."
  tts(text)
end

# Class for information screen

class Scene_PulseDex_Info
  attr_accessor :background
  attr_accessor :index

  def initialize(background, index)
    @background = background
    @index      = index
  end

  def main
    @viewport, @sprites = preparePulseDexInfo(@background)
    ttsPulse(@index)
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def update
    pbUpdateSpriteHash(@sprites)
    update_command
  end

  def update_command
    if Reborn
      if Input.trigger?(Input::RIGHT)
        changePulse(1)
      elsif Input.trigger?(Input::LEFT)
        changePulse(-1)
      end
    end
    if Input.trigger?(Input::B)
      # Switch to map screen
      pbPlayCancelSE()
      $scene = Scene_PulseDex.new(@index)
      return
    end
  end

  def changePulse(increment)
    oldindex = @index
    loop do
      @index += increment
      if @index >= getPulseInfo.length
        @index = 0
      elsif @index == 0
        @index = getPulseInfo.length - 1
      end
      break unless !$game_switches[getPulseInfo[@index][0]]
    end
    return if @index == oldindex
    pbPlayDecisionSE()
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @background = "Graphics/Pictures/#{getPulseInfo[@index][1]}" + getSuffixFile()
    @viewport, @sprites = preparePulseDexInfo(@background)
    ttsPulse(@index)
  end
end

class Scene_PulseDex_Battle
  def pbStartScene(backgrounds)
    @index = 0
    @backgrounds = backgrounds
    @viewport, @sprites = preparePulseDexInfo(@backgrounds)
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow", 8, 40, 28, 2, @viewport)
    @sprites["leftarrow"].x = 0
    @sprites["leftarrow"].y = 178
    @sprites["leftarrow"].z = 256
    @sprites["leftarrow"].play
    @sprites["leftarrow"].visible = false
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow", 8, 40, 28, 2, @viewport)
    @sprites["rightarrow"].x = 472
    @sprites["rightarrow"].y = 178
    @sprites["rightarrow"].z = 256
    @sprites["rightarrow"].play
    @sprites["rightarrow"].visible = false
    tts("Pulse 1 of #{@backgrounds.length}") if @backgrounds.length > 1
    ttsPulse(@backgrounds[@index])
    pbFadeInAndShow(@sprites)
    loop do
      Graphics.update
      Input.update
      self.update
      return if Input.trigger?(Input::B) || Input.trigger?(Input::Z)
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbSwitchPulseNotes
    @sprites["background"].setBitmap("Graphics/Pictures/#{getPulseInfo[@backgrounds[@index]][1]}")
    tts("Pulse #{@index + 1} of #{@backgrounds.length}") if @backgrounds.length > 1
    ttsPulse(@backgrounds[@index])
  end

  def update
    pbUpdateSpriteHash(@sprites)
    # update command window and the info if it's active
    if Input.trigger?(Input::B) || Input.trigger?(Input::Z)
      pbPlayCancelSE()
      return
    end
    @sprites["leftarrow"].visible = @index != 0
    @sprites["rightarrow"].visible = @index != @backgrounds.length - 1
    if Input.trigger?(Input::LEFT) && @index != 0
      pbPlayDecisionSE()
      @index -= 1
      pbSwitchPulseNotes()
    elsif Input.trigger?(Input::RIGHT) && @index != @backgrounds.length - 1
      pbPlayDecisionSE()
      @index += 1
      pbSwitchPulseNotes()
    end
  end
end
