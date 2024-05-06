#===============================================================================
# Pokédex menu screen
# * For choosing which region list to view.  Only appears when there is more
#   than one viable region list to choose from, and if DEXDEPENDSONLOCATION is
#   false.
# * Adapted from the Pokégear menu script by Maruno.
#===============================================================================
class Window_DexesList < Window_CommandPokemon
  def initialize(commands, width, seen, owned)
    @seen = seen
    @owned = owned
    super(commands, width)
    @selarrow = AnimatedBitmap.new("Graphics/Pictures/selarrowwhite")
    self.windowskin = nil
  end

  def drawItem(index, count, rect)
    super(index, count, rect)
    if index >= 0 && index < @seen.length
      pbDrawShadowText(self.contents, rect.x + 236, rect.y, 64, rect.height, @seen[index], self.baseColor, self.shadowColor, 1)
      pbDrawShadowText(self.contents, rect.x + 332, rect.y, 64, rect.height, @owned[index], self.baseColor, self.shadowColor, 1)
    end
  end
end

class Scene_PokedexMenu
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end

  def main
    commands = []; seen = []; owned = []
    dexnames = pbDexNames
    for i in 0...$PokemonGlobal.pokedexViable.length
      index = $PokemonGlobal.pokedexViable[i]
      if dexnames[index] == nil
        commands.push(_INTL("Pokédex"))
      else
        if dexnames[index].is_a?(Array)
          commands.push(dexnames[index][0])
        else
          commands.push(dexnames[index])
        end
      end
      index = -1 if index >= $PokemonGlobal.pokedexUnlocked.length - 1
      seen.push($Trainer.pokedex.getSeenCount().to_s)
      owned.push($Trainer.pokedex.getOwnedCount().to_s)
    end
    commands.push(_INTL("Exit"))
    @sprites = {}
    @sprites["background"] = IconSprite.new(0, 0)
    @sprites["background"].setBitmap("Graphics/Pictures/Pokedex/pokedexMenubg")
    @sprites["commands"] = Window_DexesList.new(commands, Graphics.width, seen, owned)
    @sprites["commands"].index = @menu_index
    @sprites["commands"].x = 42
    @sprites["commands"].y = 160
    @sprites["commands"].width = Graphics.width - 84
    @sprites["commands"].height = 224
    @sprites["commands"].windowskin = nil
    @sprites["commands"].baseColor = Color.new(248, 248, 248)
    @sprites["commands"].shadowColor = Color.new(0, 0, 0)
    @sprites["headings"] = Window_AdvancedTextPokemon.newWithSize(
      _INTL("<c3=F8F8F8,C02028>SEEN<r>OBTAINED</c3>"), 286, 104, 208, 64, @viewport
    )
    @sprites["headings"].windowskin = nil
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
  end

  def update
    pbUpdateSpriteHash(@sprites)
    if @sprites["commands"].active
      update_command
      return
    end
  end

  def update_command
    if Input.trigger?(Input::B)
      pbPlayCancelSE()
      $scene = Scene_Map.new
      return
    end
    if Input.trigger?(Input::C)
      case @sprites["commands"].index
        when @sprites["commands"].itemCount - 1
          pbPlayDecisionSE()
          $scene = Scene_Map.new
        else
          pbPlayDecisionSE()
          $PokemonGlobal.pokedexDex = $PokemonGlobal.pokedexViable[@sprites["commands"].index]
          $PokemonGlobal.pokedexDex = -1 if $PokemonGlobal.pokedexDex == $PokemonGlobal.pokedexUnlocked.length - 1
          pbFadeOutIn(99999) {
            scene = PokemonPokedexScene.new
            screen = PokemonPokedex.new(scene)
            screen.pbStartScreen
          }
      end
      return
    end
  end
end

#===============================================================================
# Pokédex main screen
#===============================================================================
class Window_CommandPokemonWhiteArrow < Window_AdvancedCommandPokemon
  def drawCursor(index, rect)
    selarrow = AnimatedBitmap.new("Graphics/Pictures/selarrowwhite")
    if self.index == index
      pbCopyBitmap(self.contents, selarrow.bitmap, rect.x, rect.y)
    end
    return Rect.new(rect.x + 16, rect.y, rect.width - 16, rect.height)
  end
end

class Window_Pokedex < Window_DrawableCommand
  def initialize(x, y, width, height)
    @pokeballOwned = AnimatedBitmap.new("Graphics/Pictures/Pokedex/pokedexOwned")
    @pokeballSeen = AnimatedBitmap.new("Graphics/Pictures/Pokedex/pokedexSeen")
    @commands = []
    super(x, y, width, height)
    self.windowskin = nil
    self.baseColor = Color.new(88, 88, 80)
    self.shadowColor = Color.new(168, 184, 184)
  end

  def drawCursor(index, rect)
    selarrow = AnimatedBitmap.new("Graphics/Pictures/Pokedex/pokedexSel")
    if self.index == index
      pbCopyBitmap(self.contents, selarrow.bitmap, rect.x, rect.y)
    end
    return Rect.new(rect.x + 16, rect.y, rect.width - 16, rect.height)
  end

  def commands=(value)
    @commands = value
    refresh
  end

  def dispose
    @pokeballOwned.dispose
    @pokeballSeen.dispose
    super
  end

  def species
    return @commands.length == 0 ? 0 : @commands[self.index][0]
  end

  def itemCount
    return @commands.length
  end

  def drawItem(index, count, rect)
    return if index >= self.top_row + self.page_item_max

    rect = drawCursor(index, rect)
    indexNumber = @commands[index][4]
    species = @commands[index][0]
    if $Trainer.pokedex.dexList[species][:seen?]
      if $Trainer.pokedex.dexList[species][:owned?]
        pbCopyBitmap(self.contents, @pokeballOwned.bitmap, rect.x - 6, rect.y + 8)
      else
        pbCopyBitmap(self.contents, @pokeballSeen.bitmap, rect.x - 6, rect.y + 8)
      end
      text = _ISPRINTF("{1:03d}{2:s} {3:s}", (@commands[index][5]) ? indexNumber - 1 : indexNumber, " ", @commands[index][1])
    else
      text = _ISPRINTF("{1:03d}  ----------", (@commands[index][5]) ? indexNumber - 1 : indexNumber)
    end
    pbDrawShadowText(self.contents, rect.x + 34, rect.y + 6, rect.width, rect.height, text, self.baseColor, self.shadowColor)
    overlapCursor = drawCursor(index - 1, itemRect(index - 1))
  end
end

class Window_ComplexCommandPokemon < Window_DrawableCommand
  attr_reader :commands

  def initialize(commands, width = nil)
    @starting = true
    @commands = commands
    dims = []
    getAutoDims(commands, dims, width)
    super(0, 0, dims[0], dims[1])
    @selarrow = AnimatedBitmap.new("Graphics/Pictures/selarrowwhite")
    @starting = false
  end

  def self.newEmpty(x, y, width, height, viewport = nil)
    ret = self.new([], width)
    ret.x = x
    ret.y = y
    ret.width = width
    ret.height = height
    ret.viewport = viewport
    return ret
  end

  def index=(value)
    super
    refresh if !@starting
  end

  def indexToCommand(index)
    curindex = 0
    i = 0; loop do
      break unless i < @commands.length
      return [i / 2, -1] if index == curindex

      curindex += 1
      return [i / 2, index - curindex] if index - curindex < commands[i + 1].length

      curindex += commands[i + 1].length
      i += 2
    end
    return [-1, -1]
  end

  def getText(array, index)
    cmd = indexToCommand(index)
    return "" if cmd[0] == -1
    return array[cmd[0] * 2] if cmd[1] < 0

    return array[cmd[0] * 2 + 1][cmd[1]]
  end

  def commands=(value)
    @commands = value
    @item_max = commands.length
    self.index = self.index
  end

  def width=(value)
    super
    if !@starting
      self.index = self.index
    end
  end

  def height=(value)
    super
    if !@starting
      self.index = self.index
    end
  end

  def resizeToFit(commands)
    dims = []
    getAutoDims(commands, dims)
    self.width = dims[0]
    self.height = dims[1]
  end

  def itemCount
    mx = 0
    i = 0; loop do
      break unless i < @commands.length

      mx += 1 + @commands[i + 1].length
      i += 2
    end
    return mx
  end

  def drawItem(index, count, rect)
    command = indexToCommand(index)
    return if command[0] < 0

    text = getText(@commands, index)
    if command[1] < 0
      pbDrawShadowText(self.contents, rect.x + 32, rect.y, rect.width, rect.height, text, self.baseColor, self.shadowColor)
    else
      rect = drawCursor(index, rect)
      pbDrawShadowText(self.contents, rect.x, rect.y, rect.width, rect.height, text, self.baseColor, self.shadowColor)
    end
  end
end

class PokemonPokedexScene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  # Gets the region used for displaying Pokédex entries.  Species will be listed
  # according to the given region's numbering and the returned region can have
  # any value defined in the town map data file.  It is currently set to the
  # return value of pbGetCurrentRegion, and thus will change according to the
  # current map's MapPosition metadata setting.
  def pbGetPokedexRegion
    if DEXDEPENDSONLOCATION
      region = pbGetCurrentRegion
      region = -1 if region >= $PokemonGlobal.pokedexUnlocked.length - 1
      return region
    else
      return $PokemonGlobal.pokedexDex # National Dex -1, regional dexes 0 etc.
    end
  end

  # Determines which index of the array $PokemonGlobal.pokedexIndex to save the
  # "last viewed species" in.  All regional dexes come first in order, then the
  # National Dex at the end.
  def pbGetSavePositionIndex
    index = pbGetPokedexRegion
    if index == -1 # National Dex
      index = $PokemonGlobal.pokedexUnlocked.length - 1 # National Dex index comes
    end # after regional Dex indices
    return index
  end

  def pbStartScene
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites["pokedex"] = Window_Pokedex.new(214, 18, 268, 332)
    @sprites["pokedex"].viewport = @viewport
    @sprites["dexentry"] = IconSprite.new(0, 0, @viewport)
    @sprites["dexentry"].setBitmap(_INTL("Graphics/Pictures/Pokedex/pokedexEntry"))
    @sprites["dexentry"].visible = false
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["overlay"].x = 0
    @sprites["overlay"].y = 0
    @sprites["overlay"].visible = false
    @sprites["searchtitle"] = Window_AdvancedTextPokemon.newWithSize("", 2, -18, Graphics.width, 64, @viewport)
    @sprites["searchtitle"].windowskin = nil
    @sprites["searchtitle"].baseColor = Color.new(248, 248, 248)
    @sprites["searchtitle"].shadowColor = Color.new(0, 0, 0)
    @sprites["searchtitle"].text = _ISPRINTF("<ac>Search Mode</ac>")
    @sprites["searchtitle"].visible = false
    @sprites["searchlist"] = Window_ComplexCommandPokemon.newEmpty(-6, 32, 284, 352, @viewport)
    @sprites["searchlist"].baseColor = Color.new(248, 248, 248)
    @sprites["searchlist"].shadowColor = Color.new(0, 0, 0)
    @sprites["searchlist"].visible = false
    if !Reborn
      @sprites["dexbar"] = IconSprite.new(0, 0, @viewport)
      @sprites["dexbar"].setBitmap(_INTL("Graphics/Pictures/Pokedex/advancedPokedexEntryBar"))
      @sprites["dexbar"].visible = false
    end
    @sprites["auxlist"] = Window_CommandPokemonWhiteArrow.newEmpty(256, 32, 284, 224, @viewport)
    @sprites["auxlist"].baseColor = Color.new(248, 248, 248)
    @sprites["auxlist"].shadowColor = Color.new(0, 0, 0)
    @sprites["auxlist"].visible = false
    @sprites["messagebox"] = Window_UnformattedTextPokemon.newWithSize("", 254, 256, 264, 128, @viewport)
    @sprites["messagebox"].baseColor = Color.new(248, 248, 248)
    @sprites["messagebox"].shadowColor = Color.new(0, 0, 0)
    @sprites["messagebox"].visible = false
    @sprites["messagebox"].letterbyletter = false
    @sprites["dexname"] = Window_AdvancedTextPokemon.newWithSize("", 2, -18, Graphics.width, 64, @viewport)
    @sprites["dexname"].windowskin = nil
    @sprites["dexname"].baseColor = Color.new(248, 248, 248)
    @sprites["dexname"].shadowColor = Color.new(0, 0, 0)
    @sprites["species"] = Window_AdvancedTextPokemon.newWithSize("", 38, 22, 160, 64, @viewport)
    @sprites["species"].windowskin = nil
    @sprites["species"].baseColor = Color.new(88, 88, 80)
    @sprites["species"].shadowColor = Color.new(168, 184, 184)
    @sprites["seen"] = Window_AdvancedTextPokemon.newWithSize("", 38, 242, 164, 64, @viewport)
    @sprites["seen"].windowskin = nil
    @sprites["seen"].baseColor = Color.new(88, 88, 80)
    @sprites["seen"].shadowColor = Color.new(168, 184, 184)
    @sprites["owned"] = Window_AdvancedTextPokemon.newWithSize("", 38, 282, 164, 64, @viewport)
    @sprites["owned"].windowskin = nil
    @sprites["owned"].baseColor = Color.new(88, 88, 80)
    @sprites["owned"].shadowColor = Color.new(168, 184, 184)
    addBackgroundPlane(@sprites, "searchbg", _INTL("Pokedex/pokedexSearchbg"), @viewport)
    @sprites["searchbg"].visible = false
    @searchResults = false
=begin
# Suggestion for changing the background depending on region.  You
# can change the line below with the following:
    if pbGetPokedexRegion==-1 # Using national Pokédex
      addBackgroundPlane(@sprites,"background","pokedexbg_national",@viewport)
    elsif pbGetPokedexRegion==0 # Using first regional Pokédex
      addBackgroundPlane(@sprites,"background","pokedexbg_regional",@viewport)
    end
=end
    addBackgroundPlane(@sprites, "background", _INTL("Pokedex/pokedexbg"), @viewport)
    @sprites["slider"] = IconSprite.new(Graphics.width - 44, 62, @viewport)
    @sprites["slider"].setBitmap(sprintf("Graphics/Pictures/Pokedex/pokedexSlider"))
    @sprites["icon"] = IconSprite.new(116, 164, @viewport)
    pbRefreshDexList($PokemonGlobal.pokedexIndex[pbGetSavePositionIndex])
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites)
    tts("Pokédex")
    tts("Seen: #{$Trainer.pokedex.getSeenCount()}")
    tts("Owned: #{$Trainer.pokedex.getOwnedCount()}")
  end

  def pbDexSearchCommands(commands, selitem, helptexts = nil)
    ret = -1
    auxlist = @sprites["auxlist"]
    messagebox = @sprites["messagebox"]
    auxlist.commands = commands
    auxlist.index = selitem
    messagebox.text = helptexts ? helptexts[auxlist.index] : ""
    tts(auxlist.commands[auxlist.index])
    tts(messagebox.text) if helptexts
    pbActivateWindow(@sprites, "auxlist") {
      loop do
        Graphics.update
        Input.update
        oldindex = auxlist.index
        pbUpdate
        if auxlist.index != oldindex
          tts(auxlist.commands[auxlist.index])
        end
        if auxlist.index != oldindex && helptexts
          messagebox.text = helptexts[auxlist.index]
          tts(messagebox.text)
        end
        if Input.trigger?(Input::B)
          ret = selitem
          pbPlayCancelSE()
          break
        end
        if Input.trigger?(Input::C)
          ret = auxlist.index
          pbPlayDecisionSE()
          break
        end
      end
      @sprites["auxlist"].commands = []
    }
    Input.update
    return ret
  end

  def pbCanAddForModeList?(mode, nationalSpecies)
    case mode
      when 0
        return true
      when 1
        return $Trainer.pokedex.dexList[nationalSpecies][:seen?]
      when 2, 3, 4, 5
        return $Trainer.pokedex.dexList[nationalSpecies][:owned?]
    end
  end

  def pbCanAddForModeSearch?(mode, nationalSpecies)
    case mode
      when 0, 1
        return $Trainer.pokedex.dexList[nationalSpecies][:seen?]
      when 2, 3, 4, 5
        return $Trainer.pokedex.dexList[nationalSpecies][:owned?]
    end
  end

  def pbGetDexList()
    dexlist = []
    region = -1
    # regionalSpecies=pbAllRegionalSpecies(region)
    # if regionalSpecies.length==1
    #  # If no regional species defined, use National Pokédex order
    #  for i in 1..$cache.pkmn.length
    #    regionalSpecies.push(i)
    #  end
    # end
    for species in $cache.pkmn.keys
      nationalSpecies = species
      if pbCanAddForModeList?($PokemonGlobal.pokedexMode, species)
        # idk what to do about this!!!!!
        lastSeenForm = $Trainer.pokedex.dexList[species][:lastSeen][:form]
        height = $cache.pkmn[species, lastSeenForm].Height
        weight = $cache.pkmn[species, lastSeenForm].Weight
        # Pushing national species, name, height, weight, index number
        shift = DEXINDEXOFFSETS.include?(region)
        dexlist.push([species, $cache.pkmn[species, lastSeenForm].name, height, weight, $cache.pkmn[species, lastSeenForm].dexnum, shift])
      end
    end
    return dexlist
  end

  def pbRefreshDexList(index = 0)
    dexlist = pbGetDexList()
    case $PokemonGlobal.pokedexMode
      when 0 # Numerical mode
        # Remove species not seen from the list
        i = 0
        loop do
          break unless i < dexlist.length
          break if $Trainer.pokedex.dexList[dexlist[i][0]][:seen?] || $cache.pkmn[dexlist[i][0], 0].dexnum < dexlist.length

          dexlist[i] = nil
          i += 1
        end
        i = dexlist.length - 1
        loop do
          break unless i >= 0
          break if !dexlist[i] || $Trainer.pokedex.dexList[dexlist[i][0]][:seen?]

          dexlist[i] = nil
          i -= 1
        end
        dexlist.compact!
        # Sort species in ascending order by index number, not national species
        dexlist.sort! { |a, b| a[4] <=> b[4] }
      when 1 # Alphabetical mode
        dexlist.sort! { |a, b| a[1] == b[1] ? a[4] <=> b[4] : a[1] <=> b[1] }
      when 2 # Heaviest mode
        dexlist.sort! { |a, b| a[3] == b[3] ? a[4] <=> b[4] : b[3] <=> a[3] }
      when 3 # Lightest mode
        dexlist.sort! { |a, b| a[3] == b[3] ? a[4] <=> b[4] : a[3] <=> b[3] }
      when 4 # Tallest mode
        dexlist.sort! { |a, b| a[2] == b[2] ? a[4] <=> b[4] : b[2] <=> a[2] }
      when 5 # Smallest mode
        dexlist.sort! { |a, b| a[2] == b[2] ? a[4] <=> b[4] : a[2] <=> b[2] }
    end
    dexname = _INTL("Pokédex")
    if $PokemonGlobal.pokedexUnlocked.length > 1
      thisdex = pbDexNames[pbGetSavePositionIndex]
      if thisdex != nil
        if thisdex.is_a?(Array)
          dexname = thisdex[0]
        else
          dexname = thisdex
        end
      end
    end
    if !@searchResults
      @sprites["seen"].text = _ISPRINTF("Seen:<r>{1:d}", $Trainer.pokedex.getSeenCount())
      @sprites["owned"].text = _ISPRINTF("Owned:<r>{1:d}", $Trainer.pokedex.getOwnedCount())
      @sprites["dexname"].text = _ISPRINTF("<ac>{1:s}</ac>", dexname)
    else
      seenno = $Trainer.pokedex.getSeenCount()
      ownedno = $Trainer.pokedex.getOwnedCount()
      @sprites["seen"].text = _ISPRINTF("Seen:<r>{1:d}", seenno)
      @sprites["owned"].text = _ISPRINTF("Owned:<r>{1:d}", ownedno)
      @sprites["dexname"].text = _ISPRINTF("<ac>{1:s} - Search results</ac>", dexname)
    end
    @dexlist = dexlist
    @sprites["pokedex"].commands = @dexlist
    @sprites["pokedex"].index = index
    @sprites["pokedex"].refresh
    # Draw the slider
    ycoord = 62
    if @sprites["pokedex"].itemCount > 1
      ycoord += 188.0 * @sprites["pokedex"].index / (@sprites["pokedex"].itemCount - 1)
    end
    @sprites["slider"].y = ycoord
    iconspecies = @sprites["pokedex"].species
    if $Trainer.pokedex.dexList[iconspecies][:seen?]
      lastGender = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:gender]
      lastForm = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:form]
      lastShiny = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:shiny]
    else
      iconspecies = nil
      lastGender = nil
      lastForm = nil
      lastShiny = false
    end
    monbitmap = pbPokemonBitmap(iconspecies, lastShiny, false, lastGender, lastForm)
    if monbitmap
      if iconspecies == :EXEGGUTOR && lastForm == "Alolan Form"
        croppedBMP = Bitmap.new(192, 192)
        croppedBMP.blt(0, 0, monbitmap, croppedBMP.rect)
        monbitmap = croppedBMP
      end
      @sprites["icon"].bitmap = monbitmap
      @sprites["icon"].ox = @sprites["icon"].bitmap.width / 2
      @sprites["icon"].oy = @sprites["icon"].bitmap.height / 2
    end
    if iconspecies != nil
      @sprites["species"].text = _ISPRINTF("<ac>{1:s}</ac>", getMonName(iconspecies, lastForm))
    else
      @sprites["species"].text = _ISPRINTF("")
    end
  end

  def pbSearchDexList(params)
    $PokemonGlobal.pokedexMode = params[4]
    dexlist = pbGetDexList()
    if params[0] != 0 # Filter by name
      nameCommands = [
        "", _INTL("ABC"), _INTL("DEF"), _INTL("GHI"),
        _INTL("JKL"), _INTL("MNO"), _INTL("PQR"),
        _INTL("STU"), _INTL("VWX"), _INTL("YZ")
      ]
      scanNameCommand = nameCommands[params[0]].scan(/./)
      dexlist = dexlist.find_all { |item|
        next false if !$Trainer.pokedex.dexList[item[0]][:seen?]

        firstChar = item[1][0, 1]
        next scanNameCommand.any? { |v| v == firstChar }
      }
    end
    if params[1] != 0 # Filter by color
      colorCommands = ["Red", "Blue", "Yellow", "Green", "Black", "Brown", "Purple", "Gray", "White", "Pink"]
      scanColorCommand = colorCommands[params[1] - 1]
      dexlist = dexlist.find_all { |item|
        next false if !$Trainer.pokedex.dexList[item[0]][:seen?]

        lastSeenForm = $Trainer.pokedex.dexList[item[0]][:lastSeen][:form]
        color = $cache.pkmn[item[0], lastSeenForm].Color
        next color == scanColorCommand
      }
    end
    if params[2] != 0 || params[3] != 0 # Filter by type
      typeCommands = [-1]
      for i in $cache.types.keys
        typeCommands.push(i) if i != :QMARKS && i != :SHADOW
      end
      stype1 = typeCommands[params[2]]
      stype2 = typeCommands[params[3]]
      dexlist = dexlist.find_all { |item|
        next false if !$Trainer.pokedex.dexList[item[0]][:owned?]

        lastSeenForm = $Trainer.pokedex.dexList[item[0]][:lastSeen][:form]
        type1 = $cache.pkmn[item[0], lastSeenForm].Type1
        type2 = $cache.pkmn[item[0], lastSeenForm].Type2
        if stype1.is_a?(Symbol) && stype2.is_a?(Symbol)
          # Find species that match both types
          next (stype1 == type1 && stype2 == type2) || (stype1 == type2 && stype2 == type1)
        elsif stype1.is_a?(Symbol)
          # Find species that match first type entered
          next type1 == stype1 || type2 == stype1
        else
          # Find species that match second type entered
          next type1 == stype2 || type2 == stype2
        end
      }
    end
    dexlist = dexlist.find_all { |item| # Remove all unseen species from the results
      next ($Trainer.pokedex.dexList[item[0]][:seen?])
    }
    case params[4]
      when 0 # Numerical mode
        # Sort by index number, not national number
        dexlist.sort! { |a, b| a[4] <=> b[4] }
      when 1 # Alphabetical mode
        dexlist.sort! { |a, b| a[1] <=> b[1] }
      when 2 # Heaviest mode
        dexlist.sort! { |a, b| b[3] <=> a[3] }
      when 3 # Lightest mode
        dexlist.sort! { |a, b| a[3] <=> b[3] }
      when 4 # Tallest mode
        dexlist.sort! { |a, b| b[2] <=> a[2] }
      when 5 # Smallest mode
        dexlist.sort! { |a, b| a[2] <=> b[2] }
    end
    return dexlist
  end

  def pbRefreshDexSearch(params)
    searchlist = @sprites["searchlist"]
    messagebox = @sprites["messagebox"]
    searchlist.commands = [
      _INTL("Search"),
      [
        _ISPRINTF("Name: {1:s}", @nameCommands[params[0]]),
        _ISPRINTF("Color: {1:s}", @colorCommands[params[1]]),
        _ISPRINTF("Type 1: {1:s}", @typeCommands[params[2]]),
        _ISPRINTF("Type 2: {1:s}", @typeCommands[params[3]]),
        _ISPRINTF("Order: {1:s}", @orderCommands[params[4]]),
        _INTL("Start Search")
      ],
      _INTL("Sort"),
      [
        _ISPRINTF("Order: {1:s}", @orderCommands[params[5]]),
        _INTL("Start Sort")
      ]
    ]
    helptexts = [
      _INTL("Search for Pokémon based on selected parameters."),
      [
        _INTL("List by the first letter in the name.\r\nSpotted Pokémon only."),
        _INTL("List by body color.\r\nSpotted Pokémon only."),
        _INTL("List by type.\r\nOwned Pokémon only."),
        _INTL("List by type.\r\nOwned Pokémon only."),
        _INTL("Select the Pokédex listing mode."),
        _INTL("Execute search."),
      ],
      _INTL("Switch Pokédex listings."),
      [
        _INTL("Select the Pokédex listing mode."),
        _INTL("Execute sort."),
      ]
    ]
    messagebox.text = searchlist.getText(helptexts, searchlist.index)
    if searchlist.index <= 6
      tts("Search Parameter:") if searchlist.index != 6
      tts(searchlist.commands[1][searchlist.index - 1])
      tts(helptexts[1][searchlist.index - 1]) if searchlist.index != 6
    else
      tts("Sort Parameter:") if searchlist.index != 9
      tts(searchlist.commands[3][searchlist.index - 8])
      tts(helptexts[3][searchlist.index - 8]) if searchlist.index != 9
    end

  end

  def pbChangeToDexEntry(species)
    if species.is_a?(Integer)
      species = $cache.pkmn.keys[species - 1]
    end
    randomgame = $game_switches[:Randomized_Challenge] == true
    $game_switches[:Randomized_Challenge] = false
    formPoke = PokeBattle_Pokemon.new(species, 1, $Trainer)
    $game_switches[:Randomized_Challenge] = randomgame
    formPoke.setGender($Trainer.pokedex.dexList[species][:lastSeen][:gender])
    formPoke.shinyflag = $Trainer.pokedex.dexList[species][:lastSeen][:shiny]
    formPoke.form = $cache.pkmn[species].forms.values.index($Trainer.pokedex.dexList[species][:lastSeen][:form])
    formPoke.form = 0 if formPoke.form.nil?
    @sprites["dexentry"].visible = true
    if !Reborn
      if @sprites["dexbar"] && $game_switches[AdvancedPokedexScene::SWITCH]
        @sprites["dexbar"].visible = true
      end
    end
    @sprites["overlay"].visible = true
    @sprites["overlay"].bitmap.clear
    basecolor = Color.new(88, 88, 80)
    shadowcolor = Color.new(168, 184, 184)
    form = formPoke.form
    speciesInt = $cache.pkmn[species, form].dexnum
    # indexNumber=pbGetRegionalNumber(pbGetPokedexRegion(),$cache.pkmn[species].dexnum)
    # indexNumber=speciesInt if indexNumber==0
    # indexNumber-=1 if DEXINDEXOFFSETS.include?(pbGetPokedexRegion)
    textpos = [
      [_ISPRINTF("{1:03d}{2:s} {3:s}", speciesInt, " ", getMonName(species, form)), 244, 40, 0, Color.new(248, 248, 248),
       Color.new(0, 0, 0)],
      [sprintf(_INTL("HT")), 318, 158, 0, basecolor, shadowcolor],
      [sprintf(_INTL("WT")), 318, 190, 0, basecolor, shadowcolor]
    ]
    if $Trainer.pokedex.dexList[species][:owned?]
      type1 = $cache.pkmn[species, form].Type1
      type2 = $cache.pkmn[species, form].Type2
      if $random_dex != nil
        type1 = $random_dex[species, form].Type1
        type2 = $random_dex[species, form].Type2
      end
      height = $cache.pkmn[species, form].Height
      weight = $cache.pkmn[species, form].Weight
      kind = $cache.pkmn[species, form].kind
      dexentry = $cache.pkmn[species, form].dexentry
      inches = (height / 0.254).round
      pounds = (weight / 0.45359).round
      textpos.push([_ISPRINTF(_INTL("{1:s} Pokémon"), kind), 244, 74, 0, basecolor, shadowcolor])
      if pbGetCountry() == 0xF4 # If the user is in the United States
        textpos.push([_ISPRINTF(_INTL("{1:d}'{2:02d}\""), inches / 12, inches % 12), 456, 158, 1, basecolor, shadowcolor])
        textpos.push([_ISPRINTF(_INTL("{1:4.1f} lbs."), pounds / 10.0), 490, 190, 1, basecolor, shadowcolor])
      else
        textpos.push([_ISPRINTF(_INTL("{1:.1f} m"), height / 10.0), 466, 158, 1, basecolor, shadowcolor])
        textpos.push([_ISPRINTF(_INTL("{1:.1f} kg"), weight / 10.0), 478, 190, 1, basecolor, shadowcolor])
      end
      drawTextEx(@sprites["overlay"].bitmap, 42, 240, Graphics.width - (42 * 2), 4, dexentry, basecolor, shadowcolor)

      footprintfile = pbPokemonFootprintFile($cache.pkmn[species, form].dexnum)
      if footprintfile
        footprint = RPG::Cache.load_bitmap(footprintfile)
        @sprites["overlay"].bitmap.blt(226, 136, footprint, footprint.rect)
        footprint.dispose
      end

      pbDrawImagePositions(@sprites["overlay"].bitmap, [["Graphics/Pictures/Pokedex/pokedexOwned", 212, 42, 0, 0, -1, -1]])
      # typebitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/Pokedex/pokedexTypes"))
      # type1rect=Rect.new(0,type1*32,96,32)
      # type2rect=Rect.new(0,type2*32,96,32)
      type1bitmap = AnimatedBitmap.new("Graphics/Pictures/Pokedex/pokedex#{type1.to_s}")
      @sprites["overlay"].bitmap.blt(296, 118, type1bitmap.bitmap, Rect.new(0, 0, 96, 32))
      type1bitmap.dispose

      if type2 != nil
        type2bitmap = AnimatedBitmap.new("Graphics/Pictures/Pokedex/pokedex#{type2.to_s}")
        @sprites["overlay"].bitmap.blt(396, 118, type2bitmap.bitmap, Rect.new(0, 0, 96, 32))
        type2bitmap.dispose
      end
    else
      textpos.push([_INTL("????? Pokémon"), 244, 74, 0, basecolor, shadowcolor])
      if pbGetCountry() == 0xF4 # If the user is in the United States
        textpos.push([_INTL("???'??\""), 456, 158, 1, basecolor, shadowcolor])
        textpos.push([_INTL("????.? lbs."), 490, 190, 1, basecolor, shadowcolor])
      else
        textpos.push([_INTL("????.? m"), 466, 158, 1, basecolor, shadowcolor])
        textpos.push([_INTL("????.? kg"), 478, 190, 1, basecolor, shadowcolor])
      end
    end
    pbDrawTextPositions(@sprites["overlay"].bitmap, textpos)
    # pkmnbitmap=AnimatedBitmap.new(pbPokemonBitmapFile(species,false))
    lastGender = $Trainer.pokedex.dexList[species][:lastSeen][:gender]
    lastForm = $Trainer.pokedex.dexList[species][:lastSeen][:form]
    lastShiny = $Trainer.pokedex.dexList[species][:lastSeen][:shiny]
    pkmnbitmap = pbPokemonBitmap(species, lastShiny, false, lastGender, lastForm)
    if formPoke.species == :EXEGGUTOR && formPoke.form == 1
      croppedBMP = Bitmap.new(192, 192)
      croppedBMP.blt(0, 0, pkmnbitmap, croppedBMP.rect)
      pkmnbitmap = croppedBMP
      @sprites["overlay"].bitmap.blt(40 - (pkmnbitmap.width - 128) / 2, (70 - (pkmnbitmap.height - 128) / 2) + 8, pkmnbitmap, pkmnbitmap.rect)
    else
      @sprites["overlay"].bitmap.blt(40 - (pkmnbitmap.width - 128) / 2, 70 - (pkmnbitmap.height - 128) / 2, pkmnbitmap, pkmnbitmap.rect)
    end
    pkmnbitmap.dispose
    pbPlayCry(formPoke)
    # tts stuff for pokedex
    tts(speciesInt.to_s)
    tts(getMonName(species, form))
    if $Trainer.pokedex.dexList[species][:owned?]
      tts(kind + " Pokémon")
      if type2 != nil
        tts("Types: " + $cache.types[type1].name + " and " + $cache.types[type2].name)
      else
        tts("Type: " + $cache.types[type1].name)
      end
      if pbGetCountry() == 0xF4 # If the user is in the United States
        tts("Height: #{inches/12} feet #{inches % 12} inches")
        tts("Weight: #{pounds / 10.0} pounds")
      else
        tts("Height: #{height / 10.0} meters")
        tts("Weight: #{weight / 10.0 } kilograms")
      end
      tts(dexentry)
    else
      tts("Unknown types")
      tts("Unknown size")
    end
  end

  def pbStartDexEntryScene(species)     # Used only when capturing a new species
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites["dexentry"] = IconSprite.new(0, 0, @viewport)
    @sprites["dexentry"].setBitmap(_INTL("Graphics/Pictures/Pokedex/pokedexentry"))
    @sprites["dexentry"].visible = false
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["overlay"].x = 0
    @sprites["overlay"].y = 0
    @sprites["overlay"].visible = false
    pbChangeToDexEntry(species)
    pbDrawImagePositions(@sprites["overlay"].bitmap, [[_INTL("Graphics/Pictures/Pokedex/pokedexBlank"), 0, 0, 0, 0, -1, -1]])
    pbFadeInAndShow(@sprites)
  end

  def pbMiddleDexEntryScene             # Used only when capturing a new species
    pbActivateWindow(@sprites, nil) {
      loop do
        Graphics.update
        Input.update
        if Input.trigger?(Input::B) || Input.trigger?(Input::C)
          break
        end
      end
    }
  end

  def pbGetCountry()
    getUserGeoID = Win32API.new("kernel32", "GetUserGeoID", "l", "i") rescue nil
    if getUserGeoID
      return getUserGeoID.call(16)
    end

    return 0
  end

  def pbDexEntry(index)
    oldsprites = pbFadeOutAndHide(@sprites)
    pbChangeToDexEntry(@dexlist[index][0])
    pbFadeInAndShow(@sprites)
    curindex = index
    page = 1
    newpage = 0
    ret = 0
    pbActivateWindow(@sprites, nil) {
      loop do
        Graphics.update if page == 1
        Input.update
        pbUpdate
        if Input.trigger?(Input::B) || ret == 1
          if page == 1
            pbPlayCancelSE()
            pbFadeOutAndHide(@sprites)
          end
          break
        elsif Input.trigger?(Input::UP) || ret == 8
          nextindex = -1
          i = curindex - 1; loop do
            break unless i >= 0

            if $Trainer.pokedex.dexList[@dexlist[i][0]][:seen?]
              nextindex = i
              break
            end
            i -= 1
          end
          if nextindex >= 0
            curindex = nextindex
            newpage = page
          end
          pbPlayCursorSE() if newpage > 1
        elsif Input.trigger?(Input::DOWN) || ret == 2
          nextindex = -1
          for i in curindex + 1...@dexlist.length
            if $Trainer.pokedex.dexList[@dexlist[i][0]][:seen?]
              nextindex = i
              break
            end
          end
          if nextindex >= 0
            curindex = nextindex
            newpage = page
          end
          pbPlayCursorSE() if newpage > 1
        elsif Input.trigger?(Input::LEFT) || ret == 4
          newpage = page - 1
          if Reborn
            if newpage < 1
              newpage = 3
            end
          else
            if newpage < 1
              newpage = ($game_switches[AdvancedPokedexScene::SWITCH] ? 4 : 3)
            end
          end
          pbPlayCursorSE() if newpage > 1
        elsif Input.trigger?(Input::RIGHT) || ret == 6
          newpage = page + 1
          if Reborn
            if newpage > 3
              newpage = 1
            end
          else
            if newpage > ($game_switches[AdvancedPokedexScene::SWITCH] ? 4 : 3)
              newpage = 1
            end
          end
          pbPlayCursorSE() if newpage > 1
        elsif Input.trigger?(Input::A)
          formPoke = PokeBattle_Pokemon.new(@dexlist[curindex][0], 1, $Trainer)
          pbPlayCry(formPoke)
        end
        ret = 0
        if newpage > 0
          page = newpage
          newpage = 0
          listlimits = 0
          listlimits += 1 if curindex == 0 # At top of list
          listlimits += 2 if curindex == @dexlist.length - 1 # At bottom of list
          case page
            when 1 # Show entry
              pbChangeToDexEntry(@dexlist[curindex][0])
            when 2 # Show nest
              region = -1
              if !DEXDEPENDSONLOCATION
                dexnames = pbDexNames
                if dexnames[pbGetSavePositionIndex].is_a?(Array)
                  region = dexnames[pbGetSavePositionIndex][1]
                end
              end
              # scene=PokemonNestMapScene.new
              # screen=PokemonNestMap.new(scene)
              # ret=screen.pbStartScreen(@dexlist[curindex][0],region,listlimits)
              region = $cache.mapdata[$game_map.map_id].MapPosition[0] if $cache.mapdata[$game_map.map_id].MapPosition
              region = pbUnpackMapHash[0] if $cache.mapdata[$game_map.map_id].MapPosition.is_a?(Hash)

              if Rejuv
                scene = PokemonRegionMapScene.new(region, true, nil)
                screen = PokemonRegionMap.new(scene)
                ret = screen.pbStartNestScene(@dexlist[curindex][0])
              else
                scene = PokemonNestMapScene.new
                screen = PokemonNestMap.new(scene)
                ret = screen.pbStartScreen(@dexlist[curindex][0], region, listlimits)
              end
            when 3 # Show forms
              scene = PokedexFormScene.new
              screen = PokedexForm.new(scene)
              ret = screen.pbStartScreen(@dexlist[curindex][0], listlimits)
            when 4 # Advanced Data
              scene = AdvancedPokedexScene.new
              screen = AdvancedPokedex.new(scene)
              ret = screen.pbStartScreen(@dexlist[curindex][0], listlimits)
          end
        end
      end
    }
    $PokemonGlobal.pokedexIndex[pbGetSavePositionIndex] = curindex if !@searchResults
    @sprites["pokedex"].index = curindex
    @sprites["pokedex"].refresh
    iconspecies = @sprites["pokedex"].species
    if $Trainer.pokedex.dexList[iconspecies][:seen?]
      lastGender = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:gender]
      lastForm = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:form]
      lastShiny = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:shiny]
    else
      iconspecies = nil
      lastGender = nil
      lastForm = nil
      lastShiny = false
    end
    monbitmap = pbPokemonBitmap(iconspecies, lastShiny, false, lastGender, lastForm)
    if monbitmap
      if iconspecies == :EXEGGUTOR && lastForm == "Alolan Form"
        croppedBMP = Bitmap.new(192, 192)
        croppedBMP.blt(0, 0, monbitmap, croppedBMP.rect)
        monbitmap = croppedBMP
      end
      @sprites["icon"].bitmap = monbitmap
      @sprites["icon"].ox = @sprites["icon"].bitmap.width / 2
      @sprites["icon"].oy = @sprites["icon"].bitmap.height / 2
    end
    if iconspecies != nil
      @sprites["species"].text = _ISPRINTF("<ac>{1:s}</ac>", getMonName(iconspecies, lastForm))
    else
      @sprites["species"].text = _ISPRINTF("")
    end
    # Update the slider
    ycoord = 62
    if @sprites["pokedex"].itemCount > 1
      ycoord += 188.0 * @sprites["pokedex"].index / (@sprites["pokedex"].itemCount - 1)
    end
    @sprites["slider"].y = ycoord
    pbFadeInAndShow(@sprites, oldsprites)
  end

  def pbDexSearch
    oldsprites = pbFadeOutAndHide(@sprites)
    params = []
    params[0] = 0
    params[1] = 0
    params[2] = 0
    params[3] = 0
    params[4] = 0
    params[5] = $PokemonGlobal.pokedexMode
    @nameCommands = [
      _INTL("Don't specify"),
      _INTL("ABC"), _INTL("DEF"), _INTL("GHI"),
      _INTL("JKL"), _INTL("MNO"), _INTL("PQR"),
      _INTL("STU"), _INTL("VWX"), _INTL("YZ")
    ]
    @typeCommands = [
      _INTL("None"),
      _INTL("Normal"), _INTL("Fighting"), _INTL("Flying"),
      _INTL("Poison"), _INTL("Ground"), _INTL("Rock"),
      _INTL("Bug"), _INTL("Ghost"), _INTL("Steel"),
      _INTL("Fire"), _INTL("Water"), _INTL("Grass"),
      _INTL("Electric"), _INTL("Psychic"), _INTL("Ice"),
      _INTL("Dragon"), _INTL("Dark"), _INTL("Fairy")
    ]
    @colorCommands = [
      _INTL("Don't specify"),
      _INTL("Red"), _INTL("Blue"), _INTL("Yellow"),
      _INTL("Green"), _INTL("Black"), _INTL("Brown"),
      _INTL("Purple"), _INTL("Gray"), _INTL("White"), _INTL("Pink")
    ]
    @orderCommands = [
      _INTL("Numeric Mode"),
      _INTL("A to Z Mode"),
      _INTL("Heaviest Mode"),
      _INTL("Lightest Mode"),
      _INTL("Tallest Mode"),
      _INTL("Smallest Mode")
    ]
    @orderHelp = [
      _INTL("Pokémon are listed according to their number."),
      _INTL("Spotted and owned Pokémon are listed alphabetically."),
      _INTL("Owned Pokémon are listed from heaviest to lightest."),
      _INTL("Owned Pokémon are listed from lightest to heaviest."),
      _INTL("Owned Pokémon are listed from tallest to smallest."),
      _INTL("Owned Pokémon are listed from smallest to tallest.")
    ]
    @sprites["searchlist"].index = 1
    searchlist = @sprites["searchlist"]
    @sprites["messagebox"].visible = true
    @sprites["auxlist"].visible = true
    @sprites["searchlist"].visible = true
    @sprites["searchbg"].visible = true
    @sprites["searchtitle"].visible = true
    tts("Search Menu: Select a parameter to change it")
    pbRefreshDexSearch(params)
    pbFadeInAndShow(@sprites)
    pbActivateWindow(@sprites, "searchlist") {
      loop do
        Graphics.update
        Input.update
        oldindex = searchlist.index
        pbUpdate
        if searchlist.index == 0
          if oldindex == 9 && Input.trigger?(Input::DOWN)
            searchlist.index = 1
          elsif oldindex == 1 && Input.trigger?(Input::UP)
            searchlist.index = 9
          else
            searchlist.index = 1
          end
        elsif searchlist.index == 7
          if oldindex == 8
            searchlist.index = 6
          else
            searchlist.index = 8
          end
        end
        if searchlist.index != oldindex
          pbRefreshDexSearch(params)
        end
        if Input.trigger?(Input::C)
          pbPlayDecisionSE()
          command = searchlist.indexToCommand(searchlist.index)
          if command == [2, 0]
            break
          end

          if command == [0, 0]
            params[0] = pbDexSearchCommands(@nameCommands, params[0])
            pbRefreshDexSearch(params)
          elsif command == [0, 1]
            params[1] = pbDexSearchCommands(@colorCommands, params[1])
            pbRefreshDexSearch(params)
          elsif command == [0, 2]
            params[2] = pbDexSearchCommands(@typeCommands, params[2])
            pbRefreshDexSearch(params)
          elsif command == [0, 3]
            params[3] = pbDexSearchCommands(@typeCommands, params[3])
            pbRefreshDexSearch(params)
          elsif command == [0, 4]
            params[4] = pbDexSearchCommands(@orderCommands, params[4], @orderHelp)
            pbRefreshDexSearch(params)
          elsif command == [0, 5]
            dexlist = pbSearchDexList(params)
            if dexlist.length == 0
              Kernel.pbMessage(_INTL("No matching Pokémon were found."))
            else
              @dexlist = dexlist
              @sprites["pokedex"].commands = @dexlist
              @sprites["pokedex"].index = 0
              @sprites["pokedex"].refresh
              iconspecies = @sprites["pokedex"].species
              if $Trainer.pokedex.dexList[iconspecies][:seen?]
                lastGender = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:gender]
                lastForm = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:form]
                lastShiny = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:shiny]
              else
                iconspecies = nil
                lastGender = nil
                lastForm = nil
                lastShiny = false
              end
              monbitmap = pbPokemonBitmap(iconspecies, lastShiny, false, lastGender, lastForm)
              if monbitmap
                if iconspecies == :EXEGGUTOR && lastForm == "Alolan Form"
                  croppedBMP = Bitmap.new(192, 192)
                  croppedBMP.blt(0, 0, monbitmap, croppedBMP.rect)
                  monbitmap = croppedBMP
                end
                @sprites["icon"].bitmap = monbitmap
                @sprites["icon"].ox = @sprites["icon"].bitmap.width / 2
                @sprites["icon"].oy = @sprites["icon"].bitmap.height / 2
              end
              if iconspecies != nil
                @sprites["species"].text = _ISPRINTF("<ac>{1:s}</ac>", getMonName(iconspecies, lastForm))
              else
                @sprites["species"].text = _ISPRINTF("")
              end
              seenno = $Trainer.pokedex.getSeenCount
              ownedno = $Trainer.pokedex.getOwnedCount
              @sprites["seen"].text = _ISPRINTF("Seen:<r>{1:d}", seenno)
              @sprites["owned"].text = _ISPRINTF("Owned:<r>{1:d}", ownedno)
              dexname = _INTL("Pokédex")
              if $PokemonGlobal.pokedexUnlocked.length > 1
                thisdex = pbDexNames[pbGetSavePositionIndex]
                if thisdex != nil
                  if thisdex.is_a?(Array)
                    dexname = thisdex[0]
                  else
                    dexname = thisdex
                  end
                end
              end
              @sprites["dexname"].text = _ISPRINTF("<ac>{1:s} - Search results</ac>", dexname)
              # Update the slider
              ycoord = 62
              if @sprites["pokedex"].itemCount > 1
                ycoord += 188.0 * @sprites["pokedex"].index / (@sprites["pokedex"].itemCount - 1)
              end
              @sprites["slider"].y = ycoord
              @searchResults = true
              break
            end
          elsif command == [1, 0]
            params[5] = pbDexSearchCommands(@orderCommands, params[5], @orderHelp)
            pbRefreshDexSearch(params)
          elsif command == [1, 1]
            $PokemonGlobal.pokedexMode = params[5]
            $PokemonGlobal.pokedexIndex[pbGetSavePositionIndex] = 0
            pbRefreshDexList
            break
          end
        elsif Input.trigger?(Input::B)
          pbPlayCancelSE()
          break
        end
      end
    }
    pbFadeOutAndHide(@sprites)
    pbFadeInAndShow(@sprites, oldsprites)
    Input.update
    return 0
  end

  def pbCloseSearch
    oldsprites = pbFadeOutAndHide(@sprites)
    @searchResults = false
    $PokemonGlobal.pokedexMode = 0
    pbRefreshDexList($PokemonGlobal.pokedexIndex[pbGetSavePositionIndex])
    pbFadeInAndShow(@sprites, oldsprites)
  end

  def pbPokedex
    pbActivateWindow(@sprites, "pokedex") {
      loop do
        Graphics.update
        Input.update
        oldindex = @sprites["pokedex"].index
        pbUpdate
        if oldindex != @sprites["pokedex"].index
          $PokemonGlobal.pokedexIndex[pbGetSavePositionIndex] = @sprites["pokedex"].index if !@searchResults
          iconspecies = @sprites["pokedex"].species
          if $Trainer.pokedex.dexList[iconspecies][:seen?]
            lastGender = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:gender]
            lastForm = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:form]
            lastShiny = $Trainer.pokedex.dexList[iconspecies][:lastSeen][:shiny]
          else
            iconspecies = nil
            lastGender = nil
            lastForm = nil
            lastShiny = false
          end
          monbitmap = pbPokemonBitmap(iconspecies, lastShiny, false, lastGender, lastForm)
          if monbitmap
            if iconspecies == :EXEGGUTOR && lastForm == "Alolan Form"
              croppedBMP = Bitmap.new(192, 192)
              croppedBMP.blt(0, 0, monbitmap, croppedBMP.rect)
              monbitmap = croppedBMP
            end
            @sprites["icon"].bitmap = monbitmap
            @sprites["icon"].ox = @sprites["icon"].bitmap.width / 2
            @sprites["icon"].oy = @sprites["icon"].bitmap.height / 2
          else
            @sprites["icon"].bitmap = nil
          end
          if iconspecies != nil
            @sprites["species"].text = _ISPRINTF("<ac>{1:s}</ac>", getMonName(iconspecies, lastForm))
          else
            @sprites["species"].text = _ISPRINTF("")
          end
          # Update the slider
          ycoord = 62
          if @sprites["pokedex"].itemCount > 1
            ycoord += 188.0 * @sprites["pokedex"].index / (@sprites["pokedex"].itemCount - 1)
          end
          @sprites["slider"].y = ycoord
          if iconspecies.nil?
            tts("#{@sprites["pokedex"].index + 1}: Unknown")
          else
            tts("#{$cache.pkmn[iconspecies, lastForm].dexnum}: #{getMonName(iconspecies)}")
          end

        end
        if Input.trigger?(Input::B)
          pbPlayCancelSE()
          if @searchResults
            pbCloseSearch
          else
            break
          end
        elsif Input.trigger?(Input::C)
          if $Trainer.pokedex.dexList[@sprites["pokedex"].species][:seen?]
            pbPlayDecisionSE()
            pbDexEntry(@sprites["pokedex"].index)
          end
        elsif Input.trigger?(Input::A) || Input.trigger?(Input::X) || Input.trigger?(Input::Y)
          pbPlayDecisionSE()
          pbDexSearch
        end
      end
    }
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokemonPokedex
  def initialize(scene)
    @scene = scene
  end

  def pbDexEntry(species)
    @scene.pbStartDexEntryScene(species)
    @scene.pbMiddleDexEntryScene
    @scene.pbEndScene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbPokedex
    @scene.pbEndScene
  end
end
