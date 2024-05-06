class RandomizerUtils
  def self.getBasicPokemon
    basicPokemon = []
    RandomizerHandler.pokemonPool.each { |pokemon|
      if !pokemon.preevolution
        basicPokemon.push(pokemon)
      end
    }
    return basicPokemon
  end

  def self.getSplitEvolutions
    splitEvos = []
    RandomizerHandler.pokemonPool.each { |pokemon|
      if pokemon.evolutions && pokemon.evolutions.length > 1
        for evoNum in 0...pokemon.evolutions.length
          next if evoNum == 0

          splitEvos.push(pokemon.evolutions[evoNum])
          end
      end
    }
    return splitEvos
  end

  def self.getMiddleEvolutions
    midEvos = []
    RandomizerHandler.pokemonPool.each { |pokemon|
      if pokemon.evolutions && pokemon.preevolution
        midEvos.push(pokemon)
      end
    }
    return midEvos
  end

  def self.getMegaEvolutions
    megas = []
    RandomizerHandler.pokemonPool.each { |pokemon|
      megas += pokemon.megaEvolutions if pokemon.megaEvolutions
    }
    return megas
  end

  def self.itemBlacklist
    ret = []
    if Gen7
      ret += [
        :TARTAPPLE, :SWEETAPPLE, :CHIPPEDPOT, :CRACKEDPOT, :RUSTEDSWORD, :RUSTEDSHIELD, :FOSSILIZEDBIRD, :FOSSILIZEDDINO,
        :FOSSILIZEDDRAKE, :FOSSILIZEDFISH,
      ]
    end
    if Reborn
      ret += [
        :GRASSMAIL
      ]
    end
    if Rejuv
      ret += [

      ]
    end
    if Desolation
      ret += [

      ]
    end
    ret
  end

  def self.getForm(species)
    return 0 if !$rndcache
    mapid = $game_map.map_id
    forms = $rndcache.encounterForms[mapid]
    return 0 if !forms
    formarr = forms[species]
    return 0 if !formarr
    form = formarr.sample
    if form.is_a?(String)
      form = $cache.pkmn[species].forms.invert[form]
    end
    form
  end
end

def checkMonsData
  puts RandomizerHandler.pokemonCache[:EEVEE, 0].Type1, RandomizerHandler.pokemonCache[:EEVEE, 0].Type2
  puts RandomizerHandler.pokemonCache[:VAPOREON, 0].Type1, RandomizerHandler.pokemonCache[:VAPOREON, 0].Type2
  puts RandomizerHandler.pokemonCache[:FLAREON, 0].Type1, RandomizerHandler.pokemonCache[:FLAREON, 0].Type2
end

class RandomizerPokemon
  attr_reader :species
  attr_reader :form
  attr_reader :formNumber
  attr_reader :data
  attr_reader :evolutions
  attr_reader :preevolution
  attr_reader :megaEvolutions
  attr_reader :shuffledStatOrder
  attr_accessor :modified

  def initialize(data, species, form)
    @data = data
    @species = species
    @form = form
    @formNumber = $cache.pkmn[species].forms.invert[form]
    @evolutions = []
    @shuffledStatOrder = [0, 1, 2, 3, 4, 5]
  end

  def setType1(type); data.setType1(type); end
  def setType2(type); @data.setType2(type); end
  def setTypes(type1, type2); @data.setTypes(type1, type2); end

  def setBaseStats(stats); @data.setBaseStats(stats); end

  def shuffleStats(random)
    @shuffledStatOrder.shuffle!(random: random)
    self.applyShuffledStats()
  end

  def copyUpShuffledStats(preevo)
    # ensure stats were not previously shuffled
    @shuffledStatOrder.sort! { |a, b| a <=> b }
    self.applyShuffledStats()
    @shuffledStatOrder = preevo.shuffledStatOrder.clone
    self.applyShuffledStats()
  end

  def applyShuffledStats
    stats = self.BaseStats
    newstats = []
    @shuffledStatOrder.each { |stat| newstats.push(stats[stat]) }
    self.setBaseStats(newstats)
  end

  def randomizeStats(random)
    if @species == :SHEDINJA
      # has one hp, gotta keep
      bst = self.bst - 51
      hpWeight = 0
    else
      bst = self.bst - 70 # minimum 20 HP, everything else min 10
      hpWeight = random.rand()
    end

    atkWeight = random.rand(); defWeight = random.rand()
    spaWeight = random.rand(); spdWeight = random.rand(); speWeight = random.rand()
    weightArr = [hpWeight, atkWeight, defWeight, spaWeight, spdWeight, speWeight]
    totWeight = weightArr.sum

    newstats = []
    newstats[0] = [1, weightArr[0] / totWeight * bst].max.to_i + 20
    newstats[1] = [1, weightArr[1] / totWeight * bst].max.to_i + 10
    newstats[2] = [1, weightArr[2] / totWeight * bst].max.to_i + 10
    newstats[3] = [1, weightArr[3] / totWeight * bst].max.to_i + 10
    newstats[4] = [1, weightArr[4] / totWeight * bst].max.to_i + 10
    newstats[5] = [1, weightArr[5] / totWeight * bst].max.to_i + 10

    self.setBaseStats(newstats)
  end

  def copyUpRandomStats(preevo)
    bstRatio = self.bst.to_f / preevo.bst.to_f

    newstats = []
    newstats[0] = [255, [1, (preevo.BaseStats[0] * bstRatio).round].max].min.to_i
    newstats[1] = [255, [1, (preevo.BaseStats[1] * bstRatio).round].max].min.to_i
    newstats[2] = [255, [1, (preevo.BaseStats[2] * bstRatio).round].max].min.to_i
    newstats[3] = [255, [1, (preevo.BaseStats[3] * bstRatio).round].max].min.to_i
    newstats[4] = [255, [1, (preevo.BaseStats[4] * bstRatio).round].max].min.to_i
    newstats[5] = [255, [1, (preevo.BaseStats[5] * bstRatio).round].max].min.to_i

    self.setBaseStats(newstats)
  end

  def setPreevolution(preevolution); @data.setPreevolution(preevolution); end
  def setPreevolutionObj(preevolution); @preevolution = preevolution; end
  def setMegaEvolutions(megaEvolutions); @megaEvolutions = megaEvolutions; end
  def setEvolutions(evolutions); @data.setEvolutions(evolutions); end
  def addEvolution(evolution); @evolutions.push(evolution); end
  def setEvolutionsObj(evolutions); @evolutions = evolutions; end

  def setAbilities(abilities); @data.setAbilities(abilities); end

  def setMoveset(moveset); @data.setMoveset(moveset); end
  def setCompatiblemoves(moves); @data.setCompatiblemoves(moves); end
  def addMove(move); @data.addMove(move); end
  def attackRatio; @data.BaseStats[1].to_f / (@data.BaseStats[1] + @data.BaseStats[3]); end

  def Type1; @data.Type1; end
  def Type2; @data.Type2; end
  def types; t = [self.Type1]; t.push(self.Type2) if self.Type2; t; end
  def bst; @data.BaseStats.sum; end
  def BaseStats; @data.BaseStats; end
  def Abilities; @data.Abilities; end
  def HiddenAbility; @data.HiddenAbility; end
  def Moveset; @data.Moveset; end
  def compatiblemoves; @data.instance_variable_get(:@compatiblemoves); end

  def getEvolutions
    @evolutions.map { |evo| { species: evo.species, form: evo.form, types: evo.types } }
  end

  def isThreeStage?
    return false if @preevolution
    return false if @evolutions.empty?
    return false if !@evolutions.any? { |mon| !mon.evolutions.empty? }
    return true
  end

  def to_s
    str = "#<RandomizerPokemon: @species=#{@species.inspect}, @form=#{@form.inspect}"
    return str + ">"
  end

  def inspect; self.to_s; end

  def ==(obj)
    return false if !obj.is_a?(RandomizerPokemon)
    return false if obj.species != @species
    return false if obj.form != @form
  end
end

class Evolution
  attr_reader :species
  attr_reader :form

  def initialize(*args)
    if args.length == 1
      @species = args[0].species
      @form = args[0].form
    else
      @species = args[0]
      @form = args[1]
    end
  end
end

class MoveData
  def setBaseDamage(value)
    @basedamage = value
  end

  def setAccuracy(value)
    @accuracy = value
  end

  def setType(value)
    @type = value
  end

  def setCategory(value)
    @category = value
  end

  def setName(name, longname)
    @name = name
    if @flags[:longname]
      @flags[:longname] = longname
    end
  end

  def export
    output = "#{@move.inspect} => {\n"
    output += "    :name => #{name.inspect},\n"
    output += sprintf("    :function => 0x%03X,\n", @function)
    output += "    :type => #{@type.inspect},\n"
    output += "    :category => #{@category.inspect},\n"
    output += "    :basedamage => #{@basedamage},\n"
    output += "    :accuracy => #{@accuracy},\n"
    output += "    :maxpp => #{@maxpp},\n"
    output += "    :target => #{@target.inspect},\n"
    output += "    :priority => #{@priority},\n" if @priority && @priority != 0
    @flags.each { |key, value| output += "    #{key.inspect} => #{value.inspect},\n" }
    output += "},\n"
    return output
  end
end

class MonData
  alias __hr_type1 Type1
  alias __hr_type2 Type2
  alias __hr_abils Abilities
  alias __hr_moves Moveset
  alias __hr_stats BaseStats
  alias __hr_evos evolutions
  alias __hr_preevo preevo
  alias __hr_compatiblemoves compatiblemoves
  def Type1
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomTypes
      return @Type1 || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@Type1) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@Type1)) || :QMARKS
    else
      return __hr_type1
    end
  end

  def Type2
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomTypes
      type = @Type2 || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@Type2) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@Type2)) || nil
      type = nil if type == self.Type1
      return type
    else
      return __hr_type2
    end
  end

  def Abilities
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomAbilities
      return @Abilities || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@Abilities) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@Abilities)) || [:ILLUMINATE]
    else
      return __hr_abils
    end
  end

  def Moveset
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMovesets
      return @Moveset || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@Moveset) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@Moveset)) || [1, :HIDDENPOWER]
    else
      return __hr_moves
    end
  end

  def BaseStats
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomStats
      return @BaseStats || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@BaseStats) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@BaseStats)) || [1, :HIDDENPOWER]
    else
      return __hr_stats
    end
  end

  def evolutions
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomEvolutions
      return @evolutions || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@evolutions) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@evolutions)) || nil
    else
      return __hr_evos
    end
  end

  def preevo
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomEvolutions
      return @preevo || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@preevo) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@preevo)) || nil
    else
      return __hr_preevo
    end
  end

  def compatiblemoves
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoveCompatibility
      return @compatiblemoves || ($rndcache.nil? ? $cache.pkmn[@species, @baseForm].instance_variable_get(:@compatiblemoves) : $rndcache.pkmn[@species, @baseForm].instance_variable_get(:@compatiblemoves)) || nil
    else
      return __hr_compatiblemoves
    end
  end

  def setType1(type); @Type1 = type; end
  def setType2(type); @Type2 = type; end
  def setTypes(type1, type2); setType1(type1); setType2(type2); end

  def setBaseStats(stats); @BaseStats = stats; end

  def setAbilities(abilities); @Abilities = abilities; @HiddenAbility = nil; end

  def setMoveset(moveset); @Moveset = moveset; moveset.each { |move| self.addMove(move) }; end

  def setEvolutions(evolutions); @evolutions = evolutions; end

  def setPreevolution(preevo); @preevo = {species: preevo[:species], form: preevo[:form]}; end

  def setCompatiblemoves(moves); @compatiblemoves = moves; end
  def addMove(move); @compatiblemoves = self.compatiblemoves if !@compatiblemoves; @compatiblemoves.push(move); end

  def export
    exporttext = ""
    exporttext += "      :name => \"#{@name}\",\n" if @name
    exporttext += "      :dexnum => #{@dexnum},\n" if @dexnum
    exporttext += "      :Type1 => :#{@Type1},\n" if @Type1
    exporttext += "      :Type2 => :#{@Type2},\n" if @Type2 && (@Type1 != @Type2)
    exporttext += "      :BaseStats => #{@BaseStats.inspect},\n" if @BaseStats
    exporttext += "      :EVs => #{@EVs.inspect},\n" if @EVs
    exporttext += "      :Abilities => #{@Abilities},\n" if @Abilities
    exporttext += "      :HiddenAbility => :#{@HiddenAbility},\n" if @HiddenAbility
    exporttext += "      :GrowthRate => :#{@GrowthRate},\n" if @GrowthRate
    exporttext += "      :GenderRatio => :#{@GenderRatio},\n" if @GenderRatio
    exporttext += "      :BaseEXP => #{@BaseEXP},\n" if @BaseEXP
    exporttext += "      :CatchRate => #{@CatchRate},\n" if @CatchRate
    exporttext += "      :Happiness => #{@Happiness},\n" if @Happiness
    exporttext += "      :EggSteps => #{@EggSteps},\n" if @EggSteps
    if @EggMoves
      if @EggMoves.empty?
        exporttext += "      :EggMoves => [],\n"
      else
        exporttext += "      :EggMoves => [\n"
        exporttext += "        "
        i = 0
        for eggmove in @EggMoves
          exporttext += ":#{eggmove}#{eggmove == @EggMoves.last ? "" : ", "}"
          i += eggmove.length + 3
          if i > 120 && eggmove != @EggMoves.last # 120 is about 10 moves, and should be the majority of the screen on a regular sized, 100% zoom monitor.
            exporttext += "\n        "
            i = 0
          end
        end
        exporttext += "\n      ],\n"
      end
    end
    if @preevo
      exporttext += "      :preevo => {\n"
      exporttext += "        :species => :#{@preevo[:species]},\n"
      exporttext += "        :form => #{@preevo[:form]}\n"
      exporttext += "      },\n"
    end
    if @Moveset
      check = 1
      exporttext += "      :Moveset => [\n"
      for move in @Moveset
        exporttext += "        [#{move[0]}, :#{move[1]}]"
        exporttext += ",\n" if check != @Moveset.length
        check += 1
      end
      exporttext += "\n      ],\n"
    end
    if @compatiblemoves
      if @compatiblemoves.empty?
        exporttext += "      :compatiblemoves => [],\n"
      else
        exporttext += "      :compatiblemoves => [\n"
        exporttext += "        "
        i = 0
        dupes = []
        for j in @compatiblemoves
          next if PBStuff::UNIVERSALTMS.include?(j)
          next if dupes.include?(j)
          dupes.push(j)
          exporttext += ":#{j}#{j == @compatiblemoves.last ? "" : ", "}"
          i += j.length + 3
          if i > 120 && j != @compatiblemoves.last
            exporttext += "\n        "
            i = 0
          end
        end
        exporttext += "\n      ],\n"
      end
    end
    if @moveexceptions
      if @moveexceptions.empty?
        exporttext += "      :moveexceptions => [],\n"
      else
        exporttext += "      :moveexceptions => [\n"
        exporttext += "        "
        i = 0
        for j in @moveexceptions
          exporttext += ":#{j}#{j == @moveexceptions.last ? "" : ", "}"
          i += j.length + 3
          if i > 120 && j != @moveexceptions.last
            exporttext += "\n        "
            i = 0
          end
        end
        exporttext += "\n      ],\n"
      end
    end
    if @shadowmoves
      if @shadowmoves.empty?
        exporttext += "      :shadowmoves => [],\n"
      else
        exporttext += "      :shadowmoves => [\n"
        exporttext += "        "
        i = 0
        for shadowmove in @shadowmoves
          exporttext += ":#{shadowmove}#{shadowmove == @shadowmoves.last ? "" : ", "}"
          i += shadowmove.length + 3
          if i > 120 && shadowmove != @shadowmoves.last
            exporttext += "\n        "
            i = 0
          end
        end
        exporttext += "\n      ],\n"
      end
    end
    exporttext += "      :Color => \"#{@Color.to_s}\",\n" if @Color
    exporttext += "      :Habitat => \"#{@Habitat.to_s}\",\n" if @Habitat
    exporttext += "      :EggGroups => #{@EggGroups.inspect},\n" if @EggGroups
    exporttext += "      :Height => #{@Height},\n" if @Height
    exporttext += "      :Weight => #{@Weight},\n" if @Weight
    exporttext += "      :kind => \"#{@kind}\",\n" if @kind
    exporttext += "      :dexentry => \"#{@dexentry}\",\n" if @dexentry
    exporttext += "      :BattlerPlayerY => #{@BattlerPlayerY},\n" if @BattlerPlayerY
    exporttext += "      :BattlerEnemyY => #{@BattlerEnemyY},\n" if @BattlerEnemyY
    exporttext += "      :BattlerAltitude => #{@BattlerAltitude},\n" if @BattlerAltitude
    if @evolutions
      evos = @evolutions
      exporttext += "      :evolutions => [\n"
      for evo in evos
        if evo.is_a?(Array)
          exporttext += "        {species: #{evo[0].inspect}, method: #{evo[1].inspect}, parameter: #{evo[2].inspect}}"
          exporttext += "," if evo != evos.last
          exporttext += "\n"
        else
          exporttext += "        {species: #{evo[:species].inspect}, method: #{evo[:method].inspect}, parameter: #{evo[:parameter].inspect}"
          exporttext += ", form: #{evo[:form].inspect}" if evo[:form]
          exporttext += "}"
          exporttext += "," if evo != evos.last
          exporttext += "\n"
        end
      end
      exporttext += "      ],\n"
    end
    if @MegaEvolutions
      exporttext += "      :MegaEvolutions => {\n"
      @MegaEvolutions.each { |method, form|
        exporttext += "        #{method.inspect} => #{form.inspect},\n"
      }
      exporttext += "      },\n"
    end
    @flags.each { |k, v| exporttext += "      #{k.inspect} => #{v.inspect},\n" }
    return exporttext
  end
end

class MonWrapper
  def export
    exporttext = "  #{@mon.inspect} => {\n"
    for form in 0...@forms.length
      formname = @forms[form]
      exporttext += "    \"#{@forms[form]}\" => {\n"
      exporttext += @pokemonData[formname].export
      exporttext += "    },\n\n"
    end
    exporttext += "    :OnCreation => #{@formInit},\n" if @formInit
    @flags.each { |k, v| exporttext += "    #{k.inspect} => #{v.inspect},\n" }
    exporttext += "  },\n\n"
    return exporttext
  end
end

Kernel.singleton_class.send(:alias_method, :__hr_itemBall, :pbItemBall)
def Kernel.pbItemBall(item, quantity = 1, plural = nil)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomItems
    return false if !item || quantity < 1
    typeMatch = $Randomizer.fieldTypeMatch
    item = $Randomizer.randomItem(item, typeMatch)
  end
  __hr_itemBall(item, quantity)
end

Kernel.singleton_class.send(:alias_method, :__hr_receiveItem, :pbReceiveItem)
def Kernel.pbReceiveItem(item, quantity = 1, plural = nil)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomItems
    return false if !item || quantity < 1
    typeMatch = $Randomizer.fieldTypeMatch
    item = $Randomizer.randomItem(item, typeMatch)
  end
  __hr_receiveItem(item, quantity)
end

class PokeBattle_Pokemon
  alias __hr_init initialize
  alias __hr_baseStats baseStats
  alias __hr_abillist getAbilityList
  alias __hr_type1 type1
  alias __hr_type2 type2
  alias __hr_moveList getMoveList
  alias __hr_makeUnmega makeUnmega
  alias __hr_makeUnprimal makeUnprimal
  alias __hr_makeUnultra makeUnultra
  alias __hr_hasMega hasMegaForm?
  alias __hr_hasUltra hasUltraForm?
  alias __hr_compat SpeciesCompatible?

  def initialize(*args)
    if $rndcache && !caller_locations.any? { |str| str.to_s.include?("pbTrainerBattle") }
      if $game_switches && $game_switches[:Randomized_Challenge]
        if $Randomizer.randomPokemon && caller_locations.any? { |str| str.to_s.include?("pbWildBattle")}
          args[0] = $cache.pkmn.keys.sample()
        end
        if $Randomizer.randomStatics && caller_locations.any? { |str| str.to_s.include?("pbWildBattle")}
          args[0] = $cache.pkmn.keys.sample()
        end
        if $Randomizer.randomEncounters && caller_locations.any? { |str| str.to_s.include?("pbWildBattle")}
          args[2] = $Trainer if !args[2]
          args[3] = false if !args[3]
          args[4] = RandomizerUtils.getForm(args[0])
        end
        if $game_switches[:Choosing_A_Starter] && $Randomizer.randomStarters && caller_locations.any? { |str| str.to_s.include?("pbAddPokemon")}
          mon = $rndcache.starters[args[0]]
          if !mon
            return __hr_init(*args)
          end
          args[0] = mon[:species]
          args[2] = $Trainer if !args[2]
          args[3] = false if !args[3]
          args[4] = mon[:form]
        end
      end
    end
    __hr_init(*args)
  end

  def baseStats
    val = __hr_baseStats
    if $rndcache
      val = $rndcache.pkmn[@species, @form].BaseStats if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomStats
    end
    val
  end

  def getAbilityList
    val = __hr_abillist
    if $rndcache
      val = $rndcache.pkmn[@species, @form].Abilities if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomAbilities
    end
    val
  end

  def type1
    val = __hr_type1
    if $rndcache
      val = $rndcache.pkmn[@species, @form].Type1 if ![:ARCEUS, :SILVALLY].include?(@species) && $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomTypes
    end
    val
  end

  def type2
    val = __hr_type2
    if $rndcache
      val = $rndcache.pkmn[@species, @form].Type2 if ![:ARCEUS, :SILVALLY].include?(@species) && $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomTypes
    end
    val
  end

  def getMoveList
    val = __hr_moveList
    if $rndcache
      val = $rndcache.pkmn[@species, @form].Moveset if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMovesets
    end
    val
  end

  def makeUnmega
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.allowMegas
      return false
    end
    __hr_makeUnmega
  end

  def makeUnprimal
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.allowMegas
      return false
    end
    __hr_makeUnprimal
  end

  def makeUnultra
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.allowMegas
      return false
    end
    __hr_makeUnultra
  end

  def hasMegaForm?
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.allowMegas
      return false
    end
    __hr_hasMega
  end

  def hasUltraForm?
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.allowMegas
      return false
    end
    __hr_hasUltra
  end

  def SpeciesCompatible?(move)
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoveCompatibility
      return $rndcache.pkmn[self.species, self.form].compatiblemoves.include?(move)
    end
    __hr_compat(move)
  end
end

class PokeBattle_Move
  alias __hr_init initialize
  def initialize(*args)
    __hr_init(*args)
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoves
      @basedamage = $rndcache.moves[@move].basedamage
      @accuracy   = $rndcache.moves[@move].accuracy
      @category   = $rndcache.moves[@move].category
      @type       = $rndcache.moves[@move].type
    end
  end
end

class PBMove
  alias __hr_type type
  alias __hr_bp basedamage
  alias __hr_acc accuracy
  alias __hr_cat category

  def type
    v = __hr_type
    v = $rndcache.moves[@move].type if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoves
    v
  end

  def basedamage
    v = __hr_bp
    v = $rndcache.moves[@move].basedamage if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoves
    v
  end

  def accuracy
    v = __hr_acc
    v = $rndcache.moves[@move].accuracy if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoves
    v
  end

  def category
    v = __hr_cat
    v = $rndcache.moves[@move].category if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoves
    v
  end
end

Events.onTrainerPartyLoad += proc { |sender, e|
  if e[0] # Trainer data should exist to be loaded, but may not exist somehow
    trainer = e[0][0] # A PokeBattle_Trainer object of the loaded trainer
    items = e[0][1]   # An array of the trainer's items they can use
    party = e[0][2]   # An array of the trainer's Pokémon
    party.each { |p|
      if $game_switches[:Randomized_Challenge]
        if $Randomizer.randomTrainers
          level = p.level
          resetName = p.name == getMonName(p.species)
          p.species = $cache.pkmn.keys.sample()
          p.level = level
          p.calcStats
          p.initAbility
          p.name = getMonName(p.species) if resetName
        end
        p.resetMoves if $Randomizer.randomMoves || $Randomizer.randomTrainers
      end
    }
  end
}

def rt
  $Randomizer = nil
  $rndcache = nil
  RandomizerScene.new
  $Randomizer.randomize
end

def moveCache
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoves
    return $rndcache.moves
  else
    return $cache.moves
  end
end

alias __hr_getEvolvedFormData pbGetEvolvedFormData
def pbGetEvolvedFormData(species, pokemon = nil)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomEvolutions
    if pokemon != nil
      return $rndcache.pkmn[species, pokemon.form].evolutions
    end

    return $rndcache.pkmn[species, $cache.pkmn[species].baseForm].evolutions
  else
    __hr_getEvolvedFormData(species, pokemon)
  end
end

alias __hr_pokeMart pbPokemonMart
def pbPokemonMart(*args)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMarts
    args[0] = getRandomStock
  end
  __hr_pokeMart(*args)
end

alias __hr_defaultMart pbDefaultMart
def pbDefaultMart(*args)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMarts
    pbPokemonMart(nil, *args)
  else
    __hr_defaultMart(*args)
  end
end

class Interpreter
  attr_reader :map_id
  attr_reader :event_id
  attr_reader :index
end

class Game_Event
  def page_index
    return @event.pages.index(@page)
  end
end

def getRandomStock
  #if pbMapInterpreterRunning?
    interp = pbMapInterpreter
    map_id = interp.map_id
    event_id = interp.event_id
    event_page = $game_map.events[event_id].page_index
    code_index = interp.index
    puts [event_id, event_page, code_index, map_id]
    mart =  $rndcache.marts.find { |loc| loc.match(event_id, event_page, code_index, map_id) }
    return mart.stock
  #else
  #  return generateStock()
  #end
end

def generateStock(stock = nil, useItemCount = false)
  if stock.nil?
    if Desolation
      case $Trainer.numbadges
        when 0
          stock = [:POKEBALL, :POTION, :ANTIDOTE, :GOURMETTREAT, :REVERSECANDY]
        when 1
          stock = [:POKEBALL, :POTION, :SUPERPOTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING, :ESCAPEROPE, :GOURMETTREAT,
                  :REVERSECANDY]
        when 2..3
          stock = [:POKEBALL, :GREATBALL, :SUPERPOTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING, :ICEHEAL, :BURNHEAL, :ESCAPEROPE, :GOURMETTREAT,
                  :REVERSECANDY]
        when 4
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :SUPERPOTION, :HYPERPOTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING, :ICEHEAL, :BURNHEAL,
                  :ESCAPEROPE, :GOURMETTREAT, :REVERSECANDY]
        when 5..6
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :HYPERPOTION, :FULLHEAL, :ESCAPEROPE, :GOURMETTREAT, :REVERSECANDY]
        when 7..10
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :HYPERPOTION, :ULTRAPOTION, :FULLHEAL, :ESCAPEROPE, :GOURMETTREAT,
                  :REVERSECANDY]
        when 11
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :HYPERPOTION, :ULTRAPOTION, :MAXPOTION, :FULLHEAL, :ESCAPEROPE, :GOURMETTREAT,
                  :REVERSECANDY]
        when 12
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :HYPERPOTION, :ULTRAPOTION, :MAXPOTION, :FULLRESTORE, :FULLHEAL, :REVIVE, :ESCAPEROPE,
                  :GOURMETTREAT, :REVERSECANDY]
        else
          stock = [:POKEBALL, :POTION, :ANTIDOTE, :GOURMETTREAT, :REVERSECANDY]
      end
    else
      case $Trainer.numbadges
        when 0
          stock = [:POTION, :ANTIDOTE, :POKEBALL]
        when 1
          stock = [:POTION, :ANTIDOTE, :PARLYZHEAL, :BURNHEAL, :ESCAPEROPE, :REPEL, :POKEBALL]
        when 2..5
          stock = [:SUPERPOTION, :ANTIDOTE, :PARLYZHEAL, :BURNHEAL, :ESCAPEROPE, :SUPERREPEL, :POKEBALL]
        when 6..9
          stock = [:SUPERPOTION, :ANTIDOTE, :PARLYZHEAL, :BURNHEAL, :ESCAPEROPE, :SUPERREPEL, :POKEBALL, :GREATBALL]
        when 10..12
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :SUPERREPEL, :MAXREPEL, :ESCAPEROPE, :FULLHEAL, :HYPERPOTION]
        when 13..16
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :SUPERREPEL, :MAXREPEL, :ESCAPEROPE, :FULLHEAL, :ULTRAPOTION]
        when 17
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :SUPERREPEL, :MAXREPEL, :ESCAPEROPE, :FULLHEAL, :ULTRAPOTION,
                   :MAXPOTION]
        when 18
          stock = [:POKEBALL, :GREATBALL, :ULTRABALL, :SUPERREPEL, :MAXREPEL, :ESCAPEROPE, :FULLHEAL, :HYPERPOTION,
                   :ULTRAPOTION, :MAXPOTION, :FULLRESTORE, :REVIVE]
        else
          stock = [:POTION, :ANTIDOTE, :POKEBALL]
      end
    end
  end
  typeMatch = $Randomizer.nil? ? false : $Randomizer.martTypeMatch # leaving implementation for future logic to perhaps utilize elsewhere - haru
  newStock = []
  newStock = stock.map { |oldItem| $Randomizer.randomItem(oldItem, typeMatch, useItemCount) }
  newStock
end

class PokeMartLocation
  attr_reader :event_id
  attr_reader :event_page
  attr_reader :code_index
  attr_reader :map_id
  attr_reader :name
  attr_accessor :stock
  def initialize(event_id, event_page, code_index, map_id, name, code)
    @event_id = event_id
    @event_page = event_page
    @map_id = map_id
    @name = name
    #@stock = code
    createStock(code)
    len = @stock ? @stock.length + 1 : 0
    @code_index = code_index + len
  end

  def createStock(code)
    # code = "pbDefaultMart()" || "pbPokemonMart(arr)"
    # if your mart code line is not explicitly these lines alone please cry
    return nil if code.include?("pbDefaultMart")
    str = code.gsub("pbPokemonMart", "extractStock")
    @stock = eval(str)
  end

  def extractStock(stock, *args); stock; end

  def setStock(stock); @stock = stock; end

  def match(event_id, event_page, code_index, map_id)
    return @event_id == event_id && @event_page == event_page && @code_index == code_index && @map_id == map_id
  end
end

class String
  # Stealing java's hashCode so text-based seed inputs are allowed. welcome friends of gargamel, 404, and glacier
  def javaHash()
    ret = 0
    each_char { |char| ret = 31 * h + char.ord }
    ret
  end
end

def extractTutorMove(move, *args); move; end

alias __hr_moveTutor pbMoveTutorChoose
def pbMoveTutorChoose(move, movelist = nil, bymachine = false)
  if $game_switches && $game_switches[:Randomized_Challenge] && !bymachine && $Randomizer.randomMoveTutors
    move = $rndcache.tutors[move]
  end
  __hr_moveTutor(move, movelist, bymachine)
end

alias __hr_addTutorMove addTutorMove
alias __hr_checkTutorMove checkTutorMove

def addTutorMove(move)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoveTutors
    move = $rndcache.tutors[move]
  end
  __hr_addTutorMove(move)
end

def checkTutorMove(move)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomMoveTutors
    move = $rndcache.tutors[move]
  end
  __hr_checkTutorMove(move)
end

alias __hr_getTM pbGetTM
def pbGetTM(item)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomTMs
    item.nil? ? false : $rndcache.items[item].checkFlag?(:tm)
  else
    __hr_getTM(item)
  end
end

class PokemonEncounters
  alias __hr_getForm pbISActuallyDifferentForm
  alias __hr_setup setup
  def pbISActuallyDifferentForm(species)
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomEncounters
      RandomizerUtils.getForm(species)
    else
      __hr_getForm(species)
    end
  end

  def setup(mapID)
    __hr_setup(mapID)
    if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomEncounters
      begin
        if $rndcache.encounters[mapID]
          encounters = $rndcache.encounters[mapID]
          @enctypes = [
            encounters[:Land].nil? ? nil : encounters[:Land], encounters[:Cave].nil? ? nil : encounters[:Cave], encounters[:Water].nil? ? nil : encounters[:Water],
            encounters[:RockSmash].nil? ? nil : encounters[:RockSmash], encounters[:OldRod].nil? ? nil : encounters[:OldRod], encounters[:GoodRod].nil? ? nil : encounters[:GoodRod],
            encounters[:SuperRod].nil? ? nil : encounters[:SuperRod], encounters[:Headbutt].nil? ? nil : encounters[:Headbutt],
            encounters[:LandMorning].nil? ? nil : encounters[:LandMorning], encounters[:LandDay].nil? ? nil : encounters[:LandDay],
            encounters[:LandNight].nil? ? nil : encounters[:LandNight], encounters[:BugContest].nil? ? nil : encounters[:BugContest],
          ]
        end
      rescue
        print "Randomizer encounters failed on Map#{sprintf("%3d",mapID)} - #{$cache.mapinfos[mapID].name}\nplease report thx <3"
      end
    end
  end
end

def printRandomizedStarter(species)
  newSpecies = $rndcache.starters[species]
  name = getMonName(newSpecies[:species])
  form = newSpecies[:form]
  kind = $cache.pkmn[newSpecies[:species], form].kind
  Kernel.pbMessage("AME: So, you want #{name}, the #{kind} Pokémon?")
end

alias __hr_addPokemon pbAddPokemon
def pbAddPokemon(*args)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomStatics && !$game_switches[:Choosing_A_Starter]
    if args[0].is_a?(Symbol)
      args[0] = $cache.pkmn.keys.sample()
    else
      poke = args[0]
      newmoves = []
      expectedmoves = []
      level = poke.level
      needsName = poke.name == getMonName(poke.species)
      moveset = poke.getMoveList
      for k in 0...moveset.length
        alevel = moveset[k][0]
        expectedmoves.push(moveset[k][1]) if alevel <= level
      end
      expectedmoves.reverse!
      expectedmoves.uniq!
      # Use the first 4 items in the move list
      expectedmoves = expectedmoves[0, 4]
      expectedmoves.reverse!

      for move in poke.moves
        newmoves.push(move.move) if !expectedmoves.include?(move.move)
      end

      poke.species = $cache.pkmn.keys.sample()
      poke.level = level
      poke.calcStats
      poke.resetMoves
      if !newmoves.empty?
        newmoves.each { |m| poke.pbLearnMove(m) }
      end
      poke.name = getMonName(poke.species) if needsName

      args[0] = poke
    end
  end
  __hr_addPokemon(*args)
end

alias __hr_addPokemonSilent pbAddPokemonSilent
def pbAddPokemonSilent(*args)
  if $game_switches && $game_switches[:Randomized_Challenge] && $Randomizer.randomStatics && !$game_switches[:Choosing_A_Starter]
    if args[0].is_a?(Symbol)
      args[0] = $cache.pkmn.keys.sample()
    else
      poke = args[0]
      newmoves = []
      expectedmoves = []
      level = poke.level
      needsName = poke.name == getMonName(poke.species)
      moveset = poke.getMoveList
      for k in 0...moveset.length
        alevel = moveset[k][0]
        expectedmoves.push(moveset[k][1]) if alevel <= level
      end
      expectedmoves.reverse!
      expectedmoves.uniq!
      # Use the first 4 items in the move list
      expectedmoves = expectedmoves[0, 4]
      expectedmoves.reverse!

      for move in poke.moves
        newmoves.push(move.move) if !expectedmoves.include?(move.move)
      end

      poke.species = $cache.pkmn.keys.sample()
      poke.level = level
      poke.calcStats
      poke.resetMoves
      if !newmoves.empty?
        newmoves.each { |m| poke.pbLearnMove(m) }
      end
      poke.name = getMonName(poke.species) if needsName

      args[0] = poke
    end
  end
  __hr_addPokemonSilent(*args)
end
