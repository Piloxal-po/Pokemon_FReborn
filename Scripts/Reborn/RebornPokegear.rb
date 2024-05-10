class Scene_Pokegear
  def setup
    @buttons = []
    @cmdMap = -1
    @cmdPhone = -1
    @cmdJukebox = -1
    @cmdOnline = -1
    @cmdPulse = -1
    @cmdNotes = -1
    @cmdWeather = -1
    @cmdTracker = -1
    if $game_switches[:Field_Notes]
      @buttons[@cmdNotes = @buttons.length] = _INTL("Field Notes")
    end
    if $game_switches[:Pulse_Dex]
      @buttons[@cmdPulse = @buttons.length] = _INTL("PULSE Dex")
    end
    @buttons[@cmdMap = @buttons.length] = _INTL("Region Map")
    @buttons[@cmdOnline = @buttons.length] = _INTL("Online Play")
    @buttons[@cmdJukebox = @buttons.length] = _INTL("Jukebox")
    @buttons[@cmdWeather = @buttons.length] = _INTL("Time & Weather")
    # @buttons[@cmdTracker=@buttons.length]=_INTL("Item Tracker")
  end

  def checkChoice
    if @cmdMap >= 0 && @sprites["command_window"].index == @cmdMap
      pbPlayDecisionSE()
      pbShowMap(-1, false)
    end
    if @cmdJukebox >= 0 && @sprites["command_window"].index == @cmdJukebox
      pbPlayDecisionSE()
      $scene = Scene_Jukebox.new
    end
    if @cmdOnline >= 0 && @sprites["command_window"].index == @cmdOnline
      pbPlayDecisionSE()
      if Kernel.pbConfirmMessage(_INTL("Would you like to save the game?"))
        if pbSave
          Kernel.pbMessage("Saved the game!")
          tryConnect
        else
          Kernel.pbMessage("Save failed.")
        end
      end
    end
    if @cmdPulse >= 0 && @sprites["command_window"].index == @cmdPulse
      pbPlayDecisionSE()
      $scene = Scene_PulseDex.new
    end
    if @cmdNotes >= 0 && @sprites["command_window"].index == @cmdNotes
      pbPlayDecisionSE()
      $scene = Scene_FieldNotes.new
    end
    if @cmdWeather >= 0 && @sprites["command_window"].index == @cmdWeather
      pbPlayDecisionSE()
      $scene = Scene_TimeWeather.new
    end
    # if @cmdTracker>=0 && @sprites["command_window"].index==@cmdTracker
    #   pbPlayDecisionSE()
    #   $scene = Scene_ItemTracker.new
    # end
  end

  def tryConnect
    $scene = Connect.new
  end
end

FIELD_NOTES_MENU = {
  "<c3=3498DB,1B4F72>Elemental Fields" => [
    :ELECTERRAIN,
    :MISTY,
    :CORROSIVEMIST,
    :GRASSY,
    :BURNING,
    :ICY,
    :WATERSURFACE,
    :MURKWATERSURFACE,
    :UNDERWATER,
    :DRAGONSDEN,
  ],
  "<c3=00bf0a,006205>Telluric Fields" => [
    :DESERT,
    :FOREST,
    :CORROSIVE,
    :CAVE,
    :ASHENBEACH,
    :SUPERHEATED,
    :SWAMP,
    :WASTELAND,
    :ROCKY,
    :MOUNTAIN,
    :SNOWYMOUNTAIN,
  ],
  "<c3=F8C471,8a461e>Synthetic Fields" => [
    :FACTORY,
    :SHORTCIRCUIT,
    :MIRROR,
    :CHESS,
    :BIGTOP,
    :GLITCH,
    :FLOWERGARDEN1,
  ],
  "<c3=BB8FCE,5B2C6F>Magical Fields" => [
    :RAINBOW,
    :CRYSTALCAVERN,
    :DARKCRYSTALCAVERN,
    :PSYTERRAIN,
    :HOLY,
    :INVERSE,
    :FAIRYTALE,
    :STARLIGHT,
    :NEWWORLD,
  ],
}

class Scene_FieldNotes
  def buildFieldMenu
    seenFields = checkSeenFields.keys.collect { |i| fieldIDToSym(i) }
    menu = []
    FIELD_NOTES_MENU.each do |category, fields|
      item = {
        label: _INTL(category),
        skip: true,
      }
      menu.push(item)
      fields.each do |field|
        if seenFields.include?(field)
          item = {
            label: "      " + $cache.FEData[field].name,
            field: field,
          }
        else
          item = {
            label: "      ???",
          }
        end
        menu.push(item)
      end
    end
    back = {
      label: _INTL("Back"),
      back: true,
    }
    menu.push(back)
    menu
  end
end
