class Cache_Randomizer
  attr_reader :misc
  attr_reader :pkmn
  attr_reader :types
  attr_reader :statics
  attr_reader :moves
  attr_reader :trainers
  attr_reader :encounters
  attr_reader :encounterForms
  attr_reader :starters
  attr_reader :tms
  attr_reader :tutors
  attr_reader :items
  attr_reader :marts

  def initialize
    @pkmn           = load_data("Randomizer Data/mons.dat")           if !@pkmn           && File.exists?("Randomizer Data/mons.dat")
    @moves          = load_data("Randomizer Data/moves.dat")          if !@moves          && File.exists?("Randomizer Data/moves.dat")
    @items          = load_data("Randomizer Data/items.dat")          if !@items          && File.exists?("Randomizer Data/items.dat")
    @marts          = load_data("Randomizer Data/marts.dat")          if !@marts          && File.exists?("Randomizer Data/marts.dat")
    @tutors         = load_data("Randomizer Data/tutors.dat")         if !@tutors         && File.exists?("Randomizer Data/tutors.dat")
    @encounters     = load_data("Randomizer Data/encounters.dat")     if !@encounters     && File.exists?("Randomizer Data/encounters.dat")
    @encounterForms = load_data("Randomizer Data/encounterForms.dat") if !@encounterForms && File.exists?("Randomizer Data/encounterForms.dat")
    @starters       = load_data("Randomizer Data/starters.dat")       if !@starters       && File.exists?("Randomizer Data/starters.dat")
  end

  #def encounters
  #  @encounters[:encounters]
  #end

  #def gifts
  #  @encounters[:gifts]
  #end

  def loadFromRandom
    @pkmn = RandomizerHandler.pokemonCache
    @moves = RandomizerHandler.movePool
    @items = RandomizerHandler.itemCache
  end
end
