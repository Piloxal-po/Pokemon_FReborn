class Cache_Game
  attr_reader :pkmn
  attr_reader :moves
  attr_reader :move2anim
  attr_reader :items
  attr_reader :trainers
  attr_reader :trainertypes
  attr_reader :FEData
  attr_reader :FENotes
  attr_reader :types
  attr_reader :abil
  attr_reader :mapinfos
  attr_reader :mapdata
  attr_reader :regions
  attr_reader :encounters
  attr_reader :metadata
  attr_reader :bosses
  # attr_reader :map_conns
  attr_reader :town_map
  attr_reader :animations
  attr_reader :RXsystem
  attr_reader :RXevents
  attr_reader :RXtilesets
  attr_reader :RXanimations
  attr_reader :cachedmaps
  attr_reader :natures
  attr_reader :shadows
  attr_reader :btmons
  attr_reader :bttrainers

  # Caching functions
  def cacheDex
    compileMons if !fileExists?(getDiri18n + "mons.dat")
    @pkmn = load_data(getDiri18n + "mons.dat") if !@pkmn
  end

  def cacheMoves
    compileMoves if !fileExists?(getDiri18n + "moves.dat")
    @moves = load_data(getDiri18n + "moves.dat") if !@moves
    @move2anim = load_data("Data/move2anim.dat") if !@move2anim
  end

  def cacheItems
    compileItems if !fileExists?(getDiri18n + "items.dat")
    @items = load_data(getDiri18n + "items.dat") if !@items
  end

  def cacheTrainers
    @trainers           = load_data(getDiri18n + "trainers.dat") if !@trainers
    compileTrainerTypes if !fileExists?("Data/ttypes.dat")
    @trainertypes       = load_data("Data/ttypes.dat") if !@trainertypes
  end

  def cacheAbilities
    compileAbilities if !fileExists?(getDiri18n + "abil.dat")
    @abil               = load_data(getDiri18n + "abil.dat") if !@abil
  end

  def cacheBattleData
    compileFields if !fileExists?(getDiri18n + "fields.dat")
    compileFieldNotes if !fileExists?(getDiri18n + "fieldnotes.dat") && !Rejuv
    compileBosses if Rejuv && !fileExists?("Data/bossdata.dat")
    @FEData             = load_data(getDiri18n + "fields.dat") if !@FEData
    @FENotes            = load_data(getDiri18n + "fieldnotes.dat") if !@FENotes && !Rejuv
    compileTypes if !fileExists?("Data/types.dat")
    cacheAbilities
    @types              = load_data("Data/types.dat") if !@types
    @bosses             = load_data("Data/bossdata.dat") if !@bosses && Rejuv
  end

  def cacheMapInfos
    @mapinfos           = load_data("Data/MapInfos.rxdata") if !@mapinfos
  end

  def cacheMetadata
    # @regions            = load_data("Data/regionals.dat") if !@regions
    @metadata           = load_data("Data/meta.dat") if !@metadata
    @mapdata            = MapDataCache.new(load_data("Data/maps.dat")) if !@mapdata
    # @map_conns          = load_data("Data/connections.dat") if !@map_conns
    @town_map           = load_data("Data/townmap.dat") if !@town_map
    @natures            = load_data("Data/natures.dat") if !@natures
    # MessageTypes.loadMessageFile("Data/Messages.dat")
  end

  def cacheBattleTower
    return if !Reborn

    compileBTMons       if !fileExists?("Data/btmons.dat")
    compileBTTrainers   if !fileExists?("Data/bttrainers.dat")
    @btmons             = load_data("Data/btmons.dat") if !@btmons
    @bttrainers         = load_data("Data/bttrainers.dat") if !@bttrainers
  end

  def initialize
    cacheDex
    cacheMoves
    cacheItems
    cacheTrainers
    cacheBattleData
    cacheMetadata
    cacheMapInfos
    cacheAnims
    cacheTilesets
    cacheBattleTower
    @RXanimations       = load_data("Data/Animations.rxdata") if !@RXanimations
    @RXevents           = load_data("Data/CommonEvents.rxdata") if !@RXevents
    @RXsystem           = load_data("Data/System.rxdata") if !@RXsystem
  end

  def cacheTilesets
    @RXtilesets         = load_data("Data/Tilesets.rxdata") if !@RXtilesets
  end

  def cacheAnims
    @animations         = load_data("Data/PkmnAnimations.rxdata") if !@animations
  end

  def animations=(value)
    @animations = value
  end

  def map_load(mapid)
    @cachedmaps = [] if !@cachedmaps
    if !@cachedmaps[mapid]
      puts "loading map " + mapid.to_s
      @cachedmaps[mapid] = load_data(sprintf("Data/Map%03d.rxdata", mapid))
    end
    return @cachedmaps[mapid]
  end
end

# Little override to return blank metadata if the map doesn't have any.
class MapDataCache < Array
  def [](index)
    data = self.fetch(index) if index < self.length
    if data.nil?
      puts "Missing metadata for map " + index.to_s
      self[index] = MapMetadata.new(index, nil, [])
      data = self.fetch(index)
    end
    return data
  end
end
