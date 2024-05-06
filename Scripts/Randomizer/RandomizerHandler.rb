class RandomizerHandler
  GENTHRESHOLDS = [
    [:BULBASAUR, :ENAMORUS], [:BULBASAUR, :MEW], [:CHIKORITA, :CELEBI], [:TREECKO, :DEOXYS],
    [:TURTWIG, :ARCEUS], [:VICTINI, :GENESECT], [:CHESPIN, :VOLCANION], [:ROWLET, :ZERAORA], [:GROOKEY, :ENAMORUS]
  ]
  COSMETICFORMS = [
    :UNOWN, :CASTFORM, :BURMY, :CHERRIM, :SHELLOS, :GASTRODON, :ARCEUS, :BASCULIN, :DEERLING, :SAWSBUCK, :KELDEO,
    :GENESECT, :VIVILLON, :FURFROU, :FLABEBE, :FLOETTE, :FLORGES, :SILVALLY, :MIMIKYU, :CRAMORANT, :TOXTRICITY,
    :SINISTEA, :POLTEAGEIST, :ALCREMIE, :MORPEKO, :ZARUDE, :OIKOLOGNE, :MAUSHOLD, :SQUAWKABILLY, :TATSUGIRI,
    :DUDUNSPARCE, :POLTCHAGEIST, :SINISTCHA
  ]
  ALLOWEDZMOVES = [
    :STOKEDSPARKSURFER, :SINISTERARROWRAID, :MALICIOUSMOONSAULT, :OCEANICOPERETTA, :EXTREMEEVOBOOST, :CATASTROPIKA,
    :PULVERIZINGPANCAKE, :GENESISSUPERNOVA, :GUARDIANOFALOLA, :SOULSTEALING7STARSTRIKE, :CLANGOROUSSOULBLAZE,
    :SPLINTEREDSTORMSHARDS, :LETSSNUGGLEFOREVER, :SEARINGSUNRAZESMASH, :MENACINGMOONRAZEMAELSTROM, :LIGHTTHATBURNSTHESKY,
  ]
  PROGRESSIONMOVES = [
    :CUT, :DIVE, :FLASH, :FLY, :MAGMADRIFT, :ROCKCLIMB, :ROCKSMASH, :STRENGTH, :SURF, :WATERFALL
  ]
  # forms that have specific conditions and/or contribute little to nothing to gameplay

  def self.initHandler(settings)
    @@settings = settings
    cprint "Initializing move pools...".white
    initMoves()
    cprint "done.\n".green
    cprint "Initializing Pokemon pools...".white
    initPokemon()
    cprint "done.\n".green
    cprint "Initializing type pools...".white
    initTypes()
    cprint "done.\n".green
    cprint "Initializing ability pools...".white
    initAbilities()
    cprint "done.\n".green
    cprint "Initializing item pools...".white
    initItems()
    cprint "done.\n".green
    cprint "Initializing encounters...".white
    initEncounters()
    cprint "done.\n".green
    #cprint "Initializing trainers...".white
    #initTrainers() if @@settings.trainers[:random]
    #cprint "done.\n".green
  end

  def self.movePool; @@movePool; end
  def self.pokemonPool; @@pokemonPool; end
  def self.pokemonCache; @@pokemonCache; end
  def self.typePool; @@typePool; end
  def self.settings; @@settings; end
  def self.itemCache; @@itemCache; end
  def self.itemPool; @@itemPool; end
  def self.tmPool; @@tmPool; end
  def self.martData; @@martData; end
  def self.tutorMapping; @@tutorMapping; end
  def self.tutorMoves; @@tutorMoves; end
  def self.encounters; @@encounters; end
  def self.formHash; @@formHash; end
  def self.starterData; @@starterData; end
  def self.staticData; @@staticData; end
  def self.staticMapData; @@staticMapData; end

  def self.rrandom
    @@settings.random
  end

  def self.rrand(*args)
    rrandom.rand(*args)
  end

  def self.maintainFormSanity
    pokemonSettings = @@settings.pkmn
    randomTypes = pokemonSettings[:types][:random]
    randomMovesets = pokemonSettings[:movesets][:random]
    randomAbilities = pokemonSettings[:abilities][:random]
    randomStats = pokemonSettings[:stats][:random] || pokemonSettings[:stats][:flipped] || pokemonSettings[:stats][:shuffle]
    randomTutors = @@settings.tutors[:random]
    randomTMs = @@settings.tms[:random]
    updateCompats = randomMovesets || randomTutors || randomTMs
    @@pokemonCache.each { |species, pokemon|
      case species
        when :TAUROS
          pokemon.forms.each { |formNumber, formName|
            next if !formName.include?("Paldean")

            baseForm = pokemon[formName].baseForm
            pokemon[formName].setType1(pokemon[baseForm].Type1) if randomTypes
            pokemon[formName].setCompatiblemoves(pokemon[baseForm].compatiblemoves) if updateCompats
          }
        when :DEOXYS, :WORMADAM, :SHAYMIN, :DARMANITAN, :HOOPA, :MEOWSTIC, :LYCANROC, :WISHIWASHI, :INDEEDEE, :CALYREX, :BASCULEGION, :OGERPON
          pokemon.forms.each { |formNumber, formName|
            baseForm = pokemon[formName].baseForm
            pokemon[formName].setType1(pokemon[baseForm].Type1) if randomTypes
            pokemon[formName].setCompatiblemoves(pokemon[baseForm].compatiblemoves) if updateCompats
          }
        when :ROTOM
          pokemon.forms.each { |formNumber, formName|
            baseForm = pokemon[formName].baseForm
            if formName != "Rotom"
              type2 = pokemon[formName].Type1
              pokemon[formName].setTypes(pokemon[baseForm].Type1, type2) if randomTypes
              pokemon[formName].setAbilities(pokemon[baseForm].Abilities) if randomAbilities
              pokemon[formName].setMoveset(pokemon[baseForm].Moveset) if randomMovesets
              pokemon[formName].setCompatiblemoves(pokemon[baseForm].compatiblemoves) if updateCompats
            end
          }
        when :DIALGA
          next if pokemon.forms.length == 1

          pokemon[1].setTypes(pokemon[0].Type1, pokemon[0].Type2) if randomTypes
          stats = pokemon[0].BaseStats
          attack = stats[1]
          spdef = stats[4]
          pokemon[1].setBaseStats([stats[0], spdef, stats[2], stats[3], attack, stats[5]]) if randomStats
          pokemon[1].setMoveset(pokemon[0].Moveset) if randomMovesets
          pokemon[1].setCompatiblemoves(pokemon[0].compatiblemoves) if updateCompats
        when :PALKIA
          next if pokemon.forms.length == 1

          pokemon[1].setTypes(pokemon[0].Type1, pokemon[0].Type2) if randomTypes
          stats = pokemon[0].BaseStats
          attack = stats[1]
          speed = stats[5]
          pokemon[1].setBaseStats([stats[0], speed, stats[2], stats[3], stats[4], attack]) if randomStats
          pokemon[1].setMoveset(pokemon[0].Moveset) if randomMovesets
          pokemon[1].setCompatiblemoves(pokemon[0].compatiblemoves) if updateCompats
        when :TORNADUS, :THUNDURUS, :LANDORUS, :ENAMORUS, :KYUREM, :ZYGARDE, :ZACIAN, :ZAMAZENTA, :URSALUNA, :PALAFIN, :GIMMIGHOUL, :TERAPAGOS
          pokemon[1].setTypes(pokemon[0].Type1, pokemon[0].Type2) if randomTypes
          pokemon[1].setCompatiblemoves(pokemon[0].compatiblemoves) if updateCompats
        when :GIRATINA, :AEGISLASH
          pokemon[1].setTypes(pokemon[0].Type1, pokemon[0].Type2) if randomTypes
          stats = pokemon[0].BaseStats
          attack = stats[1]
          defense = stats[2]
          spatk = stats[3]
          spdef = stats[4]
          pokemon[1].setBaseStats([stats[0], defense, attack, spdef, spatk, stats[5]]) if randomStats
          pokemon[1].setMoveset(pokemon[0].Moveset) if randomMovesets
          pokemon[1].setAbilities(pokemon[0].Abilities) if randomAbilities
          pokemon[1].setCompatiblemoves(pokemon[0].compatiblemoves) if updateCompats
        when :ORICORIO
          pokemon.forms.each { |formNumber, formName|
            baseForm = pokemon[formName].baseForm
            pokemon[formName].setType2(pokemon[baseForm].Type2) if randomTypes
            pokemon[formName].setCompatiblemoves(pokemon[baseForm].compatiblemoves) if updateCompats
          }
        when :MINIOR
          pokemon.forms.each { |formNumber, formName|
            baseForm = pokemon[formName].baseForm
            if formName == "Meteor Form"
              pokemon[formName].setTypes(pokemon[baseForm].Type1, pokemon[baseForm].Type2) if randomTypes
              stats = pokemon[baseForm].BaseStats
              attack = stats[1]
              defense = stats[2]
              spatk = stats[3]
              spdef = stats[4]
              pokemon[formName].setBaseStats([stats[0], defense, attack, spdef, spatk, stats[5]]) if randomStats
              pokemon[formName].setMoveset(pokemon[baseForm].Moveset) if randomMovesets
              pokemon[formName].setAbilities(pokemon[baseForm].Abilities) if randomAbilities
              pokemon[formName].setCompatiblemoves(pokemon[baseForm].compatiblemoves) if updateCompats
            else
              if formNumber != 0
                pokemon[formName].setTypes(pokemon[baseForm].Type1, pokemon[baseForm].Type2) if randomTypes
                pokemon[formName].setBaseStats(pokemon[baseForm].BaseStats) if randomStats
                pokemon[formName].setMoveset(pokemon[baseForm].Moveset) if randomMovesets
                pokemon[formName].setAbilities(pokemon[baseForm].Abilities) if randomAbilities
                pokemon[formName].setCompatiblemoves(pokemon[baseForm].compatiblemoves) if updateCompats
              end
            end
          }
        when :NECROZMA
          necroType = pokemon["Necrozma"].Type1
          solgaleo = @@pokemonCache[:SOLGALEO, 0]
          solgaType = solgaleo.Type2
          solgaType = solgaleo.Type1 if !solgaType
          solgaType = nil if solgaType == necroType
          lunala = @@pokemonCache[:LUNALA, 0]
          lunaType = lunala.Type2
          lunaType = lunala.Type1 if !lunaType
          lunaType = nil if lunaType == necroType

          pokemon["Dusk Mane"].setTypes(necroType, solgaType) if randomTypes
          pokemon["Dusk Mane"].setMoveset(pokemon["Necrozma"].Moveset) if randomMovesets
          pokemon["Dusk Mane"].setAbilities(pokemon["Necrozma"].Abilities) if randomAbilities
          pokemon["Dusk Mane"].setCompatiblemoves(pokemon["Necrozma"].compatiblemoves) if updateCompats
          pokemon["Dawn Wings"].setTypes(necroType, lunaType) if randomTypes
          pokemon["Dawn Wings"].setMoveset(pokemon["Necrozma"].Moveset) if randomMovesets
          pokemon["Dawn Wings"].setAbilities(pokemon["Necrozma"].Abilities) if randomAbilities
          pokemon["Dawn Wings"].setCompatiblemoves(pokemon["Necrozma"].compatiblemoves) if updateCompats
          pokemon["Ultra Necrozma"].setType1(necroType) if randomTypes
          pokemon["Ultra Necrozma"].setMoveset(pokemon["Necrozma"].Moveset) if randomMovesets
          pokemon["Ultra Necrozma"].setCompatiblemoves(pokemon["Necrozma"].compatiblemoves) if updateCompats
        when :URSHIFU
          pokemon[1].setType1(pokemon[0].Type1) if randomTypes
        when :LUNATONE, :SOLROCK
          next if !Rejuv
      end
    }
  end

  def self.copyUpEvolutionsHelper(baseAction, evoAction, splitAction = nil)
    basicPokemon = RandomizerUtils.getBasicPokemon
    splitEvolutions = RandomizerUtils.getSplitEvolutions
    middleEvolutions = RandomizerUtils.getMiddleEvolutions

    @@pokemonPool.each { |pokemon| pokemon.modified = false }

    basicPokemon.each { |pokemon|
      baseAction.call(pokemon)
      pokemon.modified = true
    }
    splitEvolutions.each { |pokemon| pokemon.modified = true }

    @@pokemonPool.each { |pokemon|
      next if pokemon.modified

      stack = []
      evo = pokemon
      preevo = pokemon.preevolution
      while !preevo.modified
        stack.push(evo)
        evo = evo.evolutions[0]
        preevo = evo.preevolution
      end

      evoAction.call(evo, preevo, !middleEvolutions.include?(evo))
      evo.modified = true
      while !stack.empty?
        evo = stack.pop
        preevo = evo.preevolution

        evoAction.call(evo, preevo, !middleEvolutions.include?(evo))
        evo.modified = true
      end
    }

    splitEvolutions.each { |pokemon|
      splitAction.call(pokemon, pokemon.preevolution)
      pokemon.modified = true
    }
  end

  def self.initPokemon
    @@pokemonCache = load_data("Data/mons.dat")

    @@pokemonPool = []
    @@megaList = []
    @@pokemonCache.each { |species, monWrapper|
      next if @@settings.restrictedMons.include?(species)
      next if !@@settings.misc[:allowLegendaries] && PBStuff::LEGENDARYLIST.include?(species)

      monWrapper.forms.each { |formNumber, formName|
        next if formNumber > 0 && COSMETICFORMS.include?(species)
        next if !(formNumber == 0 || formNumber = monWrapper.forms.length - 1) && species == :MINIOR

        monData = monWrapper[formName]
        next if monData.checkFlag?(:ExcludeDex) && !@@settings.misc[:allowForms]

        pokemon = RandomizerPokemon.new(monData, species, formName)
        if species == :GROUDON || species == :KYOGRE
          @@megaList.push(@@pokemonPool.last)
          @@pokemonPool.last.setMegaEvolutions([pokemon]) if formName.include?("Primal")
        end
        @@pokemonPool.push(pokemon)
      }
    }

    @@pokemonPool.each { |pokemon|
      next if pokemon.data.checkFlag?(:ExcludeDex) || @@megaList.include?(pokemon)

      if pokemon.data.preevo
        preevoData = pokemon.data.preevo
        form = @@pokemonCache[preevoData[:species]].forms[preevoData[:form]]
        preevo = @@pokemonPool.find { |p| p.species == preevoData[:species] && p.form == form }
        pokemon.setPreevolutionObj(preevo)
      end
      if pokemon.data.instance_variable_get(:@MegaEvolutions)
        megaData = pokemon.data.MegaEvolutions
        forms = megaData.map { |item, form| form }
        megas = []
        forms.each { |form|
          megas.push(
            @@pokemonPool.find { |p|
              p.species == pokemon.species && p.form == form
            }
          )
        }
        pokemon.setMegaEvolutions(megas)
        @@megaList += megas
      end
    }
    @@pokemonPool.each { |pokemon|
      next if pokemon.data.checkFlag?(:ExcludeDex) || @@megaList.include?(pokemon)
      next if pokemon.species == :WORMADAM && pokemon.preevolution.evolutions.length == 1

      if pokemon.preevolution
        preevo = pokemon.preevolution
        preevo.addEvolution(pokemon)
      end
    }
  end

# Pool Creation (UNUSED)
  def self.checkRelatives(species)
    ret = []
    mon = $cache.pkmn[species]
    forms = mon.forms.values
    if mon.preevo
      ret.push(mon.preevo[:species])
    end
    if mon.evolutions
      mon.evolutions.each { |evo| ret.push(evo[0]) }
    end
    return ret if forms.length == 1

    forms.each { |form|
      preevo = mon.formData.dig(form, :preevo)
      if preevo
        ret.push(preevo[:species])
      end
      evos = mon.formData.dig(form, :evolutions)
      if evos
        evos.each { |evo| ret.push(evo[0]) }
      end
    }
    return ret
  end

  def self.addPokemonInRange(threshold)
    ret = []
    indexA = getDex(threshold[0])
    indexB = getDex(threshold[1])

    for i in indexA...indexB
      ret.push($cache.pkmn.keys[i])
    end

    return ret
  end

  def self.getDex(species)
    return $cache.pkmn.keys.index(species)
  end

  def self.getAltForms(miscSettings)
    ret = []
    $cache.pkmn.each { |mon, data|
      next if !@@pool.include?(mon)
      next if data.forms.length == 1
      next if COSMETICFORMS.include?(mon)

      data.forms.each { |formnum, form|
        next if formnum == 0
        next if data.formData[form].dig(:ExcludeDex)
        next if (form.include?("Aevian") || form.include?("Alolan")) && !miscSettings[:allowGen7]
        next if form.include?("Galarian") && !miscSettings[:allowGen8]
        next if (form.include?("Mega") || form.include?("Primal")) && !miscSettings[:allowMegas]

        ret.push([mon, formnum])
      }
    }
    return ret
  end

# Move Randomization
  def self.initMoves
    @@movePool = load_data("Data/moves.dat")
  end

  def self.randomizeMovePower
    cprint "Randomizing move BPs...".white
    @@movePool.each { |id, move|
      next if id == :STRUGGLE || PBStuff::ANIMATIONDUMMIES.include?(id) || PBStuff::ZMOVES.include?(id)

      if move.basedamage > 1 # special function damage
        power = rrand(0..10) * 5 + 50 # [50, 100] by 5s. Regular moves
        power = rrand(0..26) * 5 + 20 if rrand(3) == 2 # [20, 150] by 5s. Extreme moves (1/3 chance)

        for i in 0...2 # 1/100 for +50, 1/10000 for +100
          power += 50 if rrand(100) == 0
        end

        if move.function == 0x0C0 # multi hit
          power = (power / 3.0).round / 5 * 5 # damage divided by average hits, rounded down to nearest 5

          power = 5 if power < 5
        end

        move.setBaseDamage(power)
      end
    }
    cprint "done.\n".green
  end

  def self.randomizeMoveAccuracy
    cprint "Randomizing move accuracies...".white
    @@movePool.each { |id, move|
      next if id == :STRUGGLE || PBStuff::ANIMATIONDUMMIES.include?(id) || PBStuff::ZMOVES.include?(id)

      if move.accuracy > 0
        # split into three categories.
        # OHKO/Dark Void should stay poor accuracy *generally* (50% and lower)
        # remaining 11% of moves are dodgy 55-85 range
        # 87.5% of moves above 0 accuracy lie within 90-100 range.
        accuracy = 0
        if move.accuracy <= 50
          # range [30,60]. should not be less than smallest chance to hit in base
          accuracy = rrand(0..6) * 5 + 30

          # 5% chance to increase accuracy by 1.5, rounding down to nearest 5
          accuracy = (move.accuracy * 1.5).round / 5 * 5 if rrand(20) == 0
        elsif move.accuracy < 90
          # range [55,95]
          accuracy = rrand(0..8) * 5 + 55
        else
          # range [80,100]
          accuracy = rrand(0..4) * 5 + 80
        end
        move.setAccuracy(accuracy)
      end
    }
    cprint "done.\n".green
  end

  def self.randomizeMoveType
    cprint "Randomizing move types...".white
    typenames = {
      :NORMAL => ["Normal"],
      :FIGHTING => ["Aura", "Qi"],
      :FLYING => ["Flying", "Air", "Wing", "Sky"],
      :POISON => ["Poison", "Acid", "Sludge", "Toxic"],
      :GROUND => ["Ground", "Earth", "Mud", "Sand"],
      :ROCK => ["Rock", "Stone"],
      :BUG => ["Bug"],
      :GHOST => ["Shadow"],
      :STEEL => ["Steel", "Iron", "Metal"],
      :FIRE => ["Fire", "Flame", "Lava", "Magma", "Heat"],
      :WATER => ["Water", "Aqua", "Hydro"],
      :GRASS => ["Grass", "Petal", "Leaf", "Solar", "Seed"],
      :ELECTRIC => ["Thunder", "Volt", "Zap", "Electro"],
      :PSYCHIC => ["Psychic", "Psycho"],
      :ICE => ["Ice", "Icicle"],
      :DRAGON => ["Dragon", "Draco"],
      :DARK => ["Dark", "Night"],
      :FAIRY => ["Fairy", "Moon"],
    }
    @@movePool.each { |id, move|
      next if id == :STRUGGLE || PBStuff::ANIMATIONDUMMIES.include?(id) || PBStuff::ZMOVES.include?(id) || move.type == :SHADOW

      # give additional chance to randomize to new type
      oldtype = move.type
      type = randomType()
      type = randomType() if oldtype == type

      move.setType(type)
      next
      next if [:PSYCHIC].include?(id)

      if @@settings.shouldRandomizeMoveNames?
        name = move.name
        longname = move.checkFlag?(:longname)
        typenames[oldtype].each { |str|
          if name.include?(str)
            newstr = typenames[type].sample(random: rrandom)
            name.gsub!(str, newstr)
            if longname
              longname.gsub!(str, newstr)
            end
          end
        }
        move.setName(name, longname)
      end
    }
    cprint "done.\n".green
  end

  def self.randomizeMoveCategory
    cprint "Randomizing move categories...".white
    @@movePool.each { |id, move|
      next if id == :STRUGGLE || PBStuff::ANIMATIONDUMMIES.include?(id) || PBStuff::ZMOVES.include?(id) || move.category == :status

      # two categories, 50% chance to swap
      move.setCategory((move.category == :physical) ? :special : :physical) if rrand(2) == 0
    }
    cprint "done.\n".green
  end

  def self.randomizeMovesets
    cprint "Randomizing movesets...".white
    movesetSettings = @@settings.pkmn[:movesets]

    metronomeOnly = movesetSettings[:metronome]
    if metronomeOnly
      @@pokemonPool.each { |pokemon|
        pokemon.setMoveset([1, :METRONOME])
      }
      return
    end

    preferType = movesetSettings[:preferType]
    scaleMoves = movesetSettings[:scaleMoves]
    banSetDamage = movesetSettings[:banSetDamage]
    newEvoMove = movesetSettings[:newEvoMove]
    forceGoodMoves = movesetSettings[:forceGoodMoves]

    @@pokemonPool.each { |pokemon|
      next if RandomizerUtils.getMegaEvolutions.include?(pokemon)

      newMoveset = []
      moveset = pokemon.Moveset
      attackRatio = pokemon.attackRatio
      # levelOnes = moveset.find_all{|movePair| movePair[0] == 1} just in case

      if newEvoMove && pokemon.preevolution
        newMoveset.push([0, randomMove()])
      end

      pickedMoves = []
      damageMoves = []
      damageMoveLevels = []
      moveset.each { |movePair|
        level = movePair[0]
        move = @@movePool[movePair[1]]

        moveType = nil
        if preferType
          # calculate expected type
          if pokemon.types.length == 1
            # 40% type match, 60% anything else
            moveType = pokemon.Type1 if rrand(100) < 40
          else
            # 20% type 1, 20% type 2, 60% other
            pick = rrand(100)
            moveType = pokemon.Type2 if pick < 40
            moveType = pokemon.Type1 if pick < 20
          end
        end

        # calculate the moves expected category based on: Attack / (Attack + Special Attack)
        moveCat = nil
        #print movePair if move.nil?
        if move.category != :status
          r = rrandom.rand
          moveCat = r < attackRatio ? :physical : :special
        end

        pickList = move.basedamage > 0 ? getDamagingMoves() : getNonDamagingMoves()
        pickList -= PBStuff::ANIMATIONDUMMIES
        pickList -= PBStuff::ZMOVES
        pickList -= [:DRAGONRAGE, :SONICBOOM] if banSetDamage
        pickList.delete(:STRUGGLE)
        # Bunch of temp checks for cases such as rules being rolled more than moves that exist for said rules (Fire status moves, etc)
        if moveType
          temp = pickList.find_all { |m| m if @@movePool[m].type != moveType }
          if (pickList - temp).length > 0
            pickList -= temp
          end
        end

        temp = pickList.find_all { |m| m if pickedMoves.include?(m) }
        if (pickList - temp).length > 0
          pickList -= temp
        end

        if moveCat
          temp = pickList.find_all { |m| m if @@movePool[m].category != moveCat }
          if (pickList - temp).length > 0
            pickList -= temp
          end
        end

        pick = pickList.sample(random: rrandom)
        if forceGoodMoves > 0
          # Check if move is already "good" (70BP or higher)
          if @@movePool[pick].basedamage < 70 && moveCat
            forcePick = rrand(100)
            if forcePick < forceGoodMoves
              # Check if any "good" moves are left in the pool
              if !pickList.any? { |m| @@movePool[m].basedamage >= 70 }
                # Add back all "good" moves if none exist
                pickList += @@movePool.keys.find_all { |m| m if @@movePool[m].basedamage >= 70 }
              end
              # Filter to remove already picked moves and "bad" moves
              pickList.delete_if { |m| @@movePool[m].basedamage < 70 || pickedMoves.include?(m) }
            end
            pick = pickList.sample(random: rrandom)
          end
        end

        # For fun, 1/100 chance to generate a special ZMove with a set effect
        pick = ALLOWEDZMOVES.sample(random: rrandom) if rrand(100) == 0

        # If we scale moves, store the level and move separately for sorting later
        if scaleMoves && @@movePool[pick].basedamage > 0
          damageMoveLevels.push(level) if move.basedamage > 0
          damageMoves.push(pick)
        else
          newMoveset.push([level, pick])
        end
        pickedMoves.push(pick)
      }

      # Sort the damage moves based on base power, store in new array
      if scaleMoves
        damageMoves.sort! { |a, b| @@movePool[a].basedamage <=> @@movePool[b].basedamage }
        for i in 0...damageMoveLevels.length
          newMoveset.push([damageMoveLevels[i], damageMoves[i]])
        end
      end
      # Ensure array is sorted by level for my own sanity
      newMoveset.sort! { |a, b| a[0] <=> b[0] }

      pokemon.setMoveset(newMoveset)
    }
    cprint "done.\n".green
  end

  def self.randomMove
    move = @@movePool.keys.sample(random: rrandom)
    while move == :STRUGGLE || PBStuff::ANIMATIONDUMMIES.include?(move) || PBStuff::ZMOVES.include?(move) ||
          (@@movePool[move].type == :SHADOW && !@@settings.types[:allowShadow?]) ||
          ([:DRAGONRAGE, :SONICBOOM].include?(move) && @@settings.pkmn[:movesets][:banSetDamage])
      move = @@movePool.keys.sample(random: rrandom)
    end
    move
  end
  def self.getDamagingMoves; return @@movePool.keys.find_all { |move| move if @@movePool[move].basedamage > 0 }; end
  def self.getNonDamagingMoves; return @@movePool.keys - getDamagingMoves(); end

# Type Randomization
  def self.initTypes
    @@typePool = load_data("Data/types.dat")
    @@typePool.delete(:QMARKS) if !@@settings.types[:allowQmarks?]
    @@typePool.delete(:SHADOW) if !@@settings.types[:allowShadow?]
  end

  def self.randomType; @@typePool.keys.sample(random: rrandom); end

  def self.randomizePokemonTypes
    cprint "Randomizing typings...".white
    followEvolutions = @@settings.pkmn[:types][:followEvolutions]
    dualType = @@settings.pkmn[:types][:dualType]

    if followEvolutions
      copyUpEvolutionsHelper(
        proc { |pokemon|
          dualType = @@settings.pkmn[:types][:dualType]
          type1 = RandomizerHandler.randomType()
          type2 = nil
          type2 = RandomizerHandler.randomType() if RandomizerHandler.rrand(100) < dualType
          while type1 == type2
            type2 = RandomizerHandler.randomType()
          end
          pokemon.setTypes(type1, type2)
        },
        proc { |evo, preevo, isFinalEvo|
          evo.setTypes(preevo.Type1, preevo.Type2)
          dualType = @@settings.pkmn[:types][:dualType]

          if !evo.Type2
            newTypeChance = dualType * (isFinalEvo ? 0.5 : 0.3)
            if RandomizerHandler.rrand(100) < newTypeChance
              type2 = RandomizerHandler.randomType()
              while evo.Type1 == type2
                type2 = RandomizerHandler.randomType()
              end
            end
            evo.setType2(type2)
          end
        },
        proc { |evo, preevo|
          evo.setType1(preevo.Type1)
          dualType = @@settings.pkmn[:types][:dualType]

          type2 = preevo.Type2
          newTypeChance = (dualType * 3) / 2
          if RandomizerHandler.rrand(100) < newTypeChance
            type2 = RandomizerHandler.randomType()
            while evo.Type1 == type2
              type2 = RandomizerHandler.randomType()
            end
          end
          evo.setType2(type2)
        }
      )

    else
      @@pokemonPool.each { |pokemon|
        type1 = randomType()
        type2 = nil
        type2 = randomType() if rrand(100) < dualType
        while type1 == type2
          type2 = randomType()
        end
        pokemon.setTypes(type1, type2)
      }
    end

    # megas
    megaEvolutions = RandomizerUtils.getMegaEvolutions
    megaEvolutions.each { |mega|
      baseForm = @@pokemonCache[mega.species, mega.data.baseForm]
      type1 = baseForm.Type1
      type2 = baseForm.Type2

      type2 = randomType() if rrand(100) < (dualType / 2)
      while type1 == type2
        type2 = randomType()
      end
      mega.setTypes(type1, type2)
    }
    cprint "done.\n".green
  end

# Evolution Randomization
  def self.randomizeEvolutions
    evoSettings = @@settings.pkmn[:evolutions]
    forceNewEvos = evoSettings[:forceNewEvos]
    limitEvos = evoSettings[:limitEvos]
    forceTyping = evoSettings[:forceTyping]
    similarTarget = evoSettings[:similarTarget]

    allowMegas = @@settings.misc[:allowMegas]

    # store old evos for later? maybe?
    @@originalEvos = {}
    @@pokemonPool.each { |pokemon|
      @@originalEvos.store(pokemon, pokemon.evolutions) if pokemon.evolutions && pokemon.evolutions.length > 0
      pokemon.setPreevolutionObj(nil)
      pokemon.setEvolutionsObj(nil)
    }

    pickedEvos = []
    picked = nil

    @@originalEvos.each { |pokemon, evolutions|
      validEvos = []
      failures = 0
      @@pokemonPool.each { |evoTo|
        # Step 1, basic checks
        # Do not let dex exclusions generate (typically no backsprites)
        next if evoTo.data.checkFlag?(:ExcludeDex) && !@@settings.misc[:allowForms]
        # Cannot be same mon
        next if pokemon == evoTo
        # Must be same growth rate
        next if pokemon.data.GrowthRate != evoTo.data.GrowthRate
        # Cannot have multiple evos into same mon
        next if pokemon.evolutions && pokemon.evolutions.include?(evoTo)
        # Check non-infinite loop
        next if evoTo.evolutions && evoTo.evolutions.include?(pokemon)
        # Force new evolution when prompted
        next if forceNewEvos && getRelatives(pokemon, true).include?(evoTo)
        # Check if mega
        next if @@megaList.include?(evoTo) && !allowMegas
        # Minior Specifically
        next if validEvos.any? { |p| p.species == :MINIOR } && evoTo.species == :MINIOR

        # Check evo limits
        if limitEvos
          next if evoTo.evolutions && pokemon.preevolution
          next if pokemon.preevolution && pokemon.preevolution.preevolution

          evos = evoTo.evolutions
          if evos
            next if evos.any? { |e| e.evolutions }
          end
        end

        validEvos.push(evoTo)
      }

      if validEvos.empty?
        # If no valid evolutions, carry on to next evo
        next
      end

      # Step 2, attempt typing force
      if forceTyping
        validEvosTypes = []
        validEvos.each { |evoTo|
          if pokemon.types.any? { |type| type != nil && evoTo.types.include?(type) }
            validEvosTypes.push(evoTo)
          end
        }
        validEvos = validEvos & validEvosTypes if validEvosTypes.length > 0 # only intersect when validEvosTypes > 0
      end

      if pickedEvos.any? { |e| validEvos.include?(e) } && (validEvos - pickedEvos).length >= 1
        validEvos -= pickedEvos
      end

      # Step 3, attempt similar target strength, select new evo
      if validEvos.length == 1
        picked = validEvos[0]
        pickedEvos.push(picked)
      elsif similarTarget
        picked = getSimilarTargetEvo(validEvos, @@originalEvos[pokemon], pickedEvos)
        pickedEvos.push(picked)
      elsif validEvos.length > 1
        picked = validEvos.sample(random: rrandom)
        pickedEvos.push(picked)
      else
        # Out of evos, go next
        next
      end

      # Step 4, add evo to pool
      form = $cache.pkmn[picked.species].forms.invert[picked.form]
      evo = {species: picked.species, method: :Level, form: form}
      evoData = $cache.pkmn[pokemon.species, pokemon.form].evolutions.find_all { |ev| ev[:method] == :Level }
      if evoData.empty?
        bst = picked.bst
        if bst >= 600
          levels = [45, 60]
        elsif bst >= 540
          levels = [38, 45]
        elsif bst >= 485
          levels = [32, 38]
        elsif bst >= 435
          levels = [28, 32]
        elsif bst >= 380
          levels = [20, 28]
        else
          levels = [7, 20]
        end
        level = rrand(levels[1] - levels[0]) + levels[0]
      else
        level = evoData[0][:parameter]
      end
      evo.store(:parameter, level)
      pokemon.setEvolutions([evo])
      pokemon.setEvolutionsObj([picked])
      picked.setPreevolution({species: pokemon.species, form: pokemon.form})
      picked.setPreevolutionObj(pokemon)
    }
  end

  def self.getSimilarTargetEvo(list, originalEvos, pickedEvos)
    # Want to check by 5% similarity each direction. Limit tries to 3?
    targetBST = 0
    originalEvos.each { |e| targetBST += e.bst }
    targetBST /= originalEvos.length
    minBST = targetBST - (targetBST / 20)
    maxBST = targetBST + (targetBST / 20)
    tries = 0
    canPick = []
    emergencyPicks = []
    while canPick.empty? || (canPick.length < 3 && tries < 3)
      list.each { |pokemon|
        if pokemon.bst <= maxBST && pokemon.bst >= minBST && !canPick.include?(pokemon) && !emergencyPicks.include?(pokemon)
          if pickedEvos.include?(pokemon)
            emergencyPicks.push(pokemon)
          else
            canPick.push(pokemon)
          end
        end
      }
      if tries >= 2 && canPick.empty?
        canPick += emergencyPicks
      end
      minBST -= (targetBST / 20)
      maxBST += (targetBST / 20)
      tries += 1
    end
    return canPick.sample(random: rrandom)
  end

  def self.getRelatives(pokemon, original = false)
    if original
      ret = []
      ret.push(pokemon)

      toCheck = []
      toCheck.push(pokemon)
      reversedEvos = pbHashForwardizer(@@originalEvos)
      while !toCheck.empty?
        check = toCheck.shift
        preevo = reversedEvos[check]
        if preevo && !ret.include?(preevo)
          toCheck.push(preevo)
          ret.push(preevo)
        end

        evo = @@originalEvos[check]
        if evo
          evo.each { |e|
            next if ret.include?(e)

            toCheck.push(e)
            ret.push(e)
          }
        end

      end

      ret.each { |p| ret += p.megaEvolutions if p.megaEvolutions }
      return ret
    else

    end
  end

# Base Stat Randomization
  def self.randomizeStats(followEvolutions)
    cprint "Randomizing base stats...".white
    if followEvolutions
      copyUpEvolutionsHelper(
        proc { |pokemon|
          pokemon.randomizeStats(rrandom)
        },
        proc { |evo, preevo, isFinalEvo|
          evo.copyUpRandomStats(preevo)
        },
        proc { |evo, preevo|
          evo.randomizeStats(rrandom)
        }
      )
    else
      @@pokemonPool.each { |pokemon|
        pokemon.randomizeStats(rrandom)
      }
    end

    # megas
    megaEvolutions = RandomizerUtils.getMegaEvolutions
    megaEvolutions.each { |mega|
      form = @@pokemonCache[mega.species].forms[mega.data.baseForm]
      baseForm = @@pokemonPool.find { |p| p.species == mega.species && p.form == form }
      mega.copyUpRandomStats(baseForm)
    }
    cprint "done.\n".green
  end

  def self.flipStats
    cprint "Flipping base stats...".white
    @@pokemonPool.each { |pokemon| pokemon.setBaseStats(pokemon.BaseStats.reverse) }
    cprint "done.\n".green
  end

  def self.shuffleStats(followEvolutions)
    cprint "Shuffling base stats...".white
    if followEvolutions
      copyUpEvolutionsHelper(
        proc { |pokemon|
          pokemon.shuffleStats(rrandom)
        },
        proc { |evo, preevo, isFinalEvo|
          evo.copyUpShuffledStats(preevo)
        },
        proc { |evo, preevo|
          evo.shuffleStats(rrandom)
        }
      )
    else
      @@pokemonPool.each { |pokemon|
        pokemon.shuffleStats(rrandom)
      }
    end

    # megas
    megaEvolutions = RandomizerUtils.getMegaEvolutions
    megaEvolutions.each { |mega|
      form = @@pokemonCache[mega.species].forms[mega.data.baseForm]
      baseForm = @@pokemonPool.find { |p| p.species == mega.species && p.form == form }
      mega.copyUpShuffledStats(baseForm)
    }
    cprint "done.\n".green
  end

# Ability Randomization
  def self.initAbilities()
    badAbilities = @@settings.badAbilities
    trappingAbilities = @@settings.trappingAbilities
    abilitySettings = @@settings.pkmn[:abilities]
    allowWonderGuard = abilitySettings[:allowWonderGuard]
    banTrappingAbilities = abilitySettings[:banTrappingAbilities]

    abilityCache = load_data("Data/abil.dat")
    @@abilityPool = abilityCache.keys
    @@abilityPool -= badAbilities
    @@abilityPool -= trappingAbilities if banTrappingAbilities
    @@abilityPool.delete(:WONDERGUARD) unless allowWonderGuard
    @@abilityPool.delete_if { |a| PBStuff::ABILITYBLACKLIST.include?(a) }
  end

  def self.randomizeAbilities
    cprint "Randomizing abilities...".white
    abilitySettings = @@settings.pkmn[:abilities]
    abilityCount = abilitySettings[:abilityCount]
    followEvolutions = abilitySettings[:followEvolutions]

    if followEvolutions
      copyUpEvolutionsHelper(proc { |pokemon|
        newAbilities = []
        if pokemon.Abilities.include?(:WONDERGUARD) || pokemon.HiddenAbility == :WONDERGUARD
          newAbilities.push(:WONDERGUARD)
        end
        if pokemon.Abilities.include?(:STANCECHANGE) || pokemon.HiddenAbility == :STANCECHANGE
          newAbilities.push(:STANCECHANGE)
        end

        while newAbilities.length < abilityCount
          ability = @@abilityPool.sample(random: rrandom)
          newAbilities.push(ability) unless newAbilities.include?(ability) ||
              (ability == :DESOLATELAND && pokemon.types.include?(:WATER)) ||
              (ability == :PRIMORDIALSEA && pokemon.types.include?(:FIRE)) ||
              (ability == :DELTASTREAM && !pokemon.types.include?(:FLYING))
        end

        pokemon.setAbilities(newAbilities)
      }, proc { |evo, preevo, isFinalEvo|
        abilities = preevo.Abilities.clone
        if evo.Abilities.include?(:WONDERGUARD) || evo.HiddenAbility == :WONDERGUARD
          abilities[0] = :WONDERGUARD
        end
        if evo.Abilities.include?(:STANCECHANGE) || evo.HiddenAbility == :STANCECHANGE
          abilities[0] = :STANCECHANGE
        end

        evo.setAbilities(abilities)
      }, proc { |evo, preevo|
        newAbilities = []
        if evo.Abilities.include?(:WONDERGUARD) || evo.HiddenAbility == :WONDERGUARD
          newAbilities.push(:WONDERGUARD)
        end
        if evo.Abilities.include?(:STANCECHANGE) || evo.HiddenAbility == :STANCECHANGE
          newAbilities.push(:STANCECHANGE)
        end

        while newAbilities.length < abilityCount
          ability = @@abilityPool.sample(random: rrandom)
          newAbilities.push(ability) unless newAbilities.include?(ability) ||
              (ability == :DESOLATELAND && evo.types.include?(:WATER)) ||
              (ability == :PRIMORDIALSEA && evo.types.include?(:FIRE)) ||
              (ability == :DELTASTREAM && !evo.types.include?(:FLYING))
        end

        evo.setAbilities(newAbilities)
      })
    else
      @@pokemonPool.each { |pokemon|
        newAbilities = []
        if pokemon.Abilities.include?(:WONDERGUARD) || pokemon.HiddenAbility == :WONDERGUARD
          newAbilities.push(:WONDERGUARD)
        end
        if pokemon.Abilities.include?(:STANCECHANGE) || pokemon.HiddenAbility == :STANCECHANGE
          newAbilities.push(:STANCECHANGE)
        end

        while newAbilities.length < abilityCount
          ability = @@abilityPool.sample(random: rrandom)
          unless newAbilities.include?(ability) ||
                 (ability == :DESOLATELAND && pokemon.types.include?(:WATER)) ||
                 (ability == :PRIMORDIALSEA && pokemon.types.include?(:FIRE)) ||
                 (ability == :DELTASTREAM && !pokemon.types.include?(:FLYING))
            newAbilities.push(ability)
          end
        end

        pokemon.setAbilities(newAbilities)
      }
    end

    # megas
    megaEvolutions = RandomizerUtils.getMegaEvolutions
    megaEvolutions.each { |mega|
      form = @@pokemonCache[mega.species].forms[mega.data.baseForm]
      baseForm = @@pokemonPool.find { |p| p.species == mega.species && p.form == form }
      mega.setAbilities(baseForm.Abilities)
      next if baseForm.megaEvolutions.length == 1

      newAbilities = []
      if baseForm.Abilities.include?(:STANCECHANGE) || baseForm.HiddenAbility == :STANCECHANGE
        newAbilities.push(:WONDERGUARD)
      end
      if baseForm.Abilities.include?(:STANCECHANGE) || baseForm.HiddenAbility == :STANCECHANGE
        newAbilities.push(:STANCECHANGE)
      end

      while newAbilities.length < abilityCount
        ability = @@abilityPool.sample(random: rrandom)
        unless newAbilities.include?(ability) ||
               (ability == :DESOLATELAND && mega.types.include?(:WATER)) ||
               (ability == :PRIMORDIALSEA && mega.types.include?(:FIRE)) ||
               (ability == :DELTASTREAM && !mega.types.include?(:FLYING))
          newAbilities.push(ability)
        end
      end

      mega.setAbilities(newAbilities)
    }
    cprint "done.\n".green
  end

# Item/Tutor Randomization
  def self.initItems
    @@itemCache = load_data("Data/items.dat")
    @@tmPool = {}
    @@storyPool = {}
    @@itemPool = @@itemCache.keys

    @@itemCache.each { |item, data|
      @@itemPool.delete(item) if  data.checkFlag?(:questitem) || (data.checkFlag?(:keyitem) && !data.checkFlag?(:legendary))
      @@storyPool.store(item, data) if data.checkFlag?(:questitem)
      @@tmPool.store(item, data) if data.checkFlag?(:tm) && !@@storyPool.keys.include?(item)
    }
  end

  def self.gatherMartLocations
    # IF THIS IS BREAKING
    # YOUR MART SCRIPT DOES NOT EXIST IN A SCRIPT COMMAND BY ITSELF (code 355)
    @@martData = []
    for n in 1..999
      map_name = sprintf("Data/Map%03d.rxdata", n)
      next if !File.exists?(map_name)
      next if !(File.open(map_name, "rb") { true } rescue false)
      cprint "Checking file #{map_name}\r"

      map = load_data(map_name)
      mapDisplayName = $cache.mapinfos[n].name
      next if mapDisplayName.downcase.include?("removed")
      if $Trainer
        mapDisplayName = mapDisplayName.gsub(/\\PN/, $Trainer.name)
      end
      for i in map.events.keys.sort
        event = map.events[i]
        for j in 0...event.pages.length
          page = event.pages[j]
          list = page.list
          index = 0
          while index < list.length - 1
            if list[index].code == 355 #|| list[index].code == 655
              code = list[index].parameters[0]
              if code.include?("pbPokemonMart") || code.include?("pbDefaultMart")
                stockCode = code.dup
                scrIndex = index + 1
                while list[scrIndex].code == 655
                  stockCode += list[scrIndex].parameters[0]
                  scrIndex += 1
                end
                @@martData.push(PokeMartLocation.new(i, j, index, n, mapDisplayName, stockCode))
              end
            end
            index += 1
          end
        end
      end
    end
    cprint "                                    \n"
  end

  def self.gatherTutorLocations
    # IF THIS IS BREAKING
    # idk
    @@tutorMoves = []
    for n in 1..999
      map_name = sprintf("Data/Map%03d.rxdata", n)
      next if !File.exists?(map_name)
      next if !(File.open(map_name, "rb") { true } rescue false)
      cprint "Checking file #{map_name}\r"

      map = load_data(map_name)
      mapDisplayName = $cache.mapinfos[n].name
      next if mapDisplayName.downcase.include?("removed")
      for i in map.events.keys.sort
        event = map.events[i]
        for j in 0...event.pages.length
          page = event.pages[j]
          list = page.list
          index = 0
          while index < list.length - 1
            if list[index].code == 355 || list[index].code == 655 || (list[index].code == 111 && list[index].parameters[0] == 12)
              code = list[index].parameters[0]
              code = list[index].parameters[1] if list[index].code == 111
              if code.include?("pbMoveTutorChoose")
                move = eval(code.gsub("pbMoveTutorChoose", "extractTutorMove"))
                @@tutorMoves.push(move)
              end
            end
            index += 1
          end
        end
      end
    end
    cprint "                                    \n"
  end

  def self.randomizeMarts
    gatherMartLocations()
    typeMatch = @@settings.items[:mart][:typeMatch]

    @@martData.each { |loc|
      stock = loc.stock
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
      newStock = []
      newStock = stock.map { |oldItem|
        item = randomItem(oldItem, typeMatch)
        while $cache.items[item].checkFlag?(:justsell)
          item = randomItem(oldItem, typeMatch)
        end
        item
      }
      loc.setStock(newStock)
    }

  end

  def self.randomItem(item, typeMatch)
    # return the original item if it's a key item, quest item, or side quest item
    return item if $cache.items[item].checkFlag?(:keyitem) || $cache.items[item].checkFlag?(:questitem) || $cache.items[item].checkFlag?(:sidequest) || RandomizerUtils.itemBlacklist.include?(item)

    pool = $cache.items.keys
    # remove any items that are quest items or key items (but leave items like DNA Splicers)
    pool.delete_if { |i|
      $cache.items[i].checkFlag?(:questitem) || ($cache.items[i].checkFlag?(:keyitem) && !$cache.items[i].checkFlag?(:legendary)) || RandomizerUtils.itemBlacklist.include?(item)
    }
    # remove any items from differing pockets
    pool.delete_if { |i| pbGetPocket(i) != pbGetPocket(item) } if typeMatch
    # power matching for zcrystals
    if $cache.items[item].checkFlag?(:crystal)
      if $cache.items[item].checkFlag?(:zcrystal)
        pool.delete_if { |i|
          !$cache.items[i].checkFlag?(:zcrystal) || PBStuff::MOVETOZCRYSTAL.values.include?(i)
        }
      else
        pool.delete_if { |i|
          $cache.items[i].checkFlag?(:zcrystal) && !PBStuff::MOVETOZCRYSTAL.values.include?(i)
        }
      end
    end
    # sample
    item = pool.sample(random: rrandom)
    # increment the item calls so we can reliably pull the same items but still feel random
    item
  end

  def self.randomizeTMs
    tmSettings = @@settings.tms
    typeCompatibility = tmSettings[:typeCompatibility]
    randomCompatibility = tmSettings[:randomCompatibility]
    fullCompatibility = tmSettings[:fullCompatibility]
    forceGoodMoves = tmSettings[:forceGoodMoves]
    compatibility = {}

    @@tmPool.each { |item, data|
      oldMove = data.checkFlag?(:tm).dup
      newMove = randomMove()

      # check if the move is "good" and force if rolled
      if forceGoodMoves > 0
        if rrand(100) < forceGoodMoves
          while @@movePool[newMove].basedamage < 70
            newMove = randomMove()
          end
        end
      end

      # ensure the move has not been made a TM already
      while compatibility.values.include?(newMove) || PROGRESSIONMOVES.include?(newMove)
        newMove = randomMove()
        if forceGoodMoves > 0
          if rrand(100) < forceGoodMoves
            while @@movePool[newMove].basedamage < 70
              newMove = randomMove()
            end
          end
        end
      end

      # 1% chance for z move again
      newMove = ALLOWEDZMOVES.sample(random: rrandom) if rrand(100) == 0

      # map old compatibility to the new move for later
      compatibility.store(oldMove, newMove)
      data.flags[:tm] = newMove
    }

    maintainMoveSanity(compatibility, typeCompatibility, randomCompatibility, fullCompatibility)
  end

  def self.randomizeMoveTutors
    gatherTutorLocations()
    tutorSettings = @@settings.tutors
    typeCompatibility = tutorSettings[:typeCompatibility]
    randomCompatibility = tutorSettings[:randomCompatibility]
    fullCompatibility = tutorSettings[:fullCompatibility]
    forceGoodMoves = tutorSettings[:forceGoodMoves]
    @@tutorMapping = {}

    @@tutorMoves.each { |oldMove|
      newMove = randomMove()

      # check if the move is "good" and force if rolled
      if forceGoodMoves > 0
        if rrand(100) < forceGoodMoves
          while @@movePool[newMove].basedamage < 70
            newMove = randomMove()
          end
        end
      end

      # ensure the move has not been made a TM already
      while @@tutorMapping.values.include?(newMove) || PROGRESSIONMOVES.include?(newMove)
        newMove = randomMove()
        if forceGoodMoves > 0
          if rrand(100) < forceGoodMoves
            while @@movePool[newMove].basedamage < 70
              newMove = randomMove()
            end
          end
        end
      end

      # 1% chance for z move again again
      newMove = ALLOWEDZMOVES.sample(random: rrandom) if rrand(100) == 0

      @@tutorMapping.store(oldMove, newMove)
    }

    maintainMoveSanity(@@tutorMapping, typeCompatibility, randomCompatibility, fullCompatibility)
  end

  def self.maintainMoveSanity(compatibility, typeCompatibility, randomCompatibility, fullCompatibility)
    # check compatibility method
    if typeCompatibility
      # 90% chance for Pokemon to get TM/Tutor if they share a type
      # 50% chance for Pokemon to get TM/Tutor if move is Normal
      # 25% chance for Pokemon to get TM/Tutor otherwise
      @@pokemonPool.each { |pokemon|
        compatiblemoves = pokemon.compatiblemoves
        next if !compatiblemoves
        types = pokemon.types
        compatibility.values.each { |move|
          next if compatiblemoves.include?(move)
          if types.include?(@@movePool[move].type)
            pokemon.addMove(move) if rrand(100) < 90
          elsif @@movePool[move].type == :NORMAL
            pokemon.addMove(move) if rrand(100) < 50
          else
            pokemon.addMove(move) if rrand(100) < 25
          end
        }
      }
    elsif randomCompatibility
      # 50% chance for Pokemon to get TM/Tutor move.
      @@pokemonPool.each { |pokemon|
        compatiblemoves = pokemon.compatiblemoves
        next if !compatiblemoves
        compatibility.values.each { |move|
          next if compatiblemoves.include?(move)
          pokemon.addMove(move) if rrand(100) < 50
        }
      }
    elsif fullCompatibility
      # All Pokemon get every move
      @@pokemonPool.each { |pokemon|
        compatiblemoves = pokemon.compatiblemoves
        next if !compatiblemoves
        compatibility.values.each { |move|
          next if compatiblemoves.include?(move)
          pokemon.addMove(move)
        }
      }
    else
      # Takes the created map of old moves >> new moves and ensures every Pokemon can learn a move provided they were compatible with the original.
      @@pokemonPool.each { |pokemon|
        compatiblemoves = pokemon.compatiblemoves
        next if !compatiblemoves
        compatibility.each { |oldMove, newMove|
          next if compatiblemoves.include?(newMove)
          pokemon.addMove(newMove) if compatiblemoves.include?(oldMove)
        }
      }

    end
  end

# Encounter Randomization
  def self.initEncounters
    File.open("Scripts/#{GAMEFOLDER}/enctext.rb", "r") { |f| eval(f.read) }
    @@encounters = ENCHASH.dup
    @@starterData = {}
    @@staticData = {
      :OMANYTE => nil, :KABUTO => nil, :AERODACTYL => nil,
      :LILEEP => nil, :ANORITH => nil,
      :CRANIDOS => nil, :SHIELDON => nil,
      :TIRTOUGA => nil, :ARCHEN => nil,
      :TYRUNT => nil, :AMAURA => nil,
    }
    @@staticData += {:DRACOZOLT => nil, :DRACOVISH => nil, :ARCTOZOLT => nil, :ARCTOVISH => nil} if !Gen7
    fossilMap = 0
    fossilMap = 242 if Reborn
    fossilMap = 0 if Rejuv
    fossilMap = 0 if Desolation
    @@staticMapData = {}
    @@staticMapData.store(fossilMap, [
      :OMANYTE, :KABUTO, :AERODACTYL,
      :LILEEP, :ANORITH,
      :CRANIDOS, :SHIELDON,
      :TIRTOUGA, :ARCHEN,
      :TYRUNT, :AMAURA,
    ])
    @@staticMapData[fossilMap] += [:DRACOZOLT, :DRACOVISH, :ARCTOZOLT, :ARCTOVISH] if !Gen7
    gatherStaticPokemon
    @@encounterPool = @@pokemonPool.dup
    @@encounterPool.delete_if { |mon|
      (PBStuff::LEGENDARYLIST.include?(mon.species) && @@settings.encounters[:disableLegends]) ||
      (RandomizerUtils.getMegaEvolutions.include?(mon) && !@@settings.misc[:allowMegas])
    }
    @@formHash = {}
  end

  def self.gatherStaticPokemon
    for n in 1..999
      map_name = sprintf("Data/Map%03d.rxdata", n)
      next if !File.exists?(map_name)
      next if !(File.open(map_name, "rb") { true } rescue false)
      cprint "Checking file #{map_name}                                 \r"

      map = load_data(map_name)
      mapDisplayName = $cache.mapinfos[n].name
      next if mapDisplayName.downcase.include?("removed")
      if $Trainer
        mapDisplayName = mapDisplayName.gsub(/\\PN/, $Trainer.name)
      end
      for i in map.events.keys.sort
        event = map.events[i]
        for j in 0...event.pages.length
          page = event.pages[j]
          list = page.list
          index = 0
          while index < list.length - 1
            if list[index].code == 355
              code = list[index].parameters[0]
              if code.include?("$game_variables[700]")
                index += 1
                next
              elsif code.include?("pbAddPokemon")
                string = code.gsub("pbAddPokemonSilent(", "extractPokemon(#{n},")
                string = code.gsub("pbAddPokemon(", "extractPokemon(#{n},") if code == string
                eval(string)
                index += 1
                next
              else
                staticCode = code.dup
                scrIndex = index + 1
                while list[scrIndex].code == 655
                  staticCode += "\n" + list[scrIndex].parameters[0]
                  scrIndex += 1
                end
                if staticCode.include?("pbAddPokemon")
                  string = staticCode.gsub("pbAddPokemonSilent(", "extractPokemon(#{n},")
                  string = staticCode.gsub("pbAddPokemon(", "extractPokemon(#{n},") if staticCode == string
                  eval(string)
                end

              end
            end

            if list[index].code == 111 && list[index].parameters[0] == 12
              code = list[index].parameters[1]
              if code.include?("pbAddPokemon")
                string = code.gsub("pbAddPokemonSilent(", "extractPokemon(#{n},")
                string = code.gsub("pbAddPokemon(", "extractPokemon(#{n},") if code == string
                eval(string)
              end
            end
            index += 1
          end
        end
      end
    end
    cprint "                                    \r"
    cprint "Initializing encounters...".white
  end

  def self.extractPokemon(map, *args)
    starterMap = 0
    fossilMap = 0
    (starterMap = 39; fossilMap = 242) if Reborn
    (starterMap = 0; fossilMap = 0) if Rejuv
    (starterMap = 0; fossilMap = 0) if Desolation
    return if map == fossilMap
    if args[0].is_a?(PokeBattle_Pokemon)
      species = args[0].species
    else
      species = args[0]
    end
    @@starterData.store(species, nil) if map == starterMap
    if map != starterMap
      @@staticData.store(species, nil)
      @@staticMapData[map] = [] if !@@staticMapData[map]
      @@staticMapData[map].push(species)
    end

  end

  def self.randomizeEncounters
    encounterSettings = @@settings.encounters
    areamap = encounterSettings[:areamap]
    globalmap = encounterSettings[:globalmap]
    similarBST = encounterSettings[:similarBST]
    typeThemed = encounterSettings[:typeThemed]
    items = encounterSettings[:items]
    minCatchRate = encounterSettings[:minCatchRate]

    formHash = {}
    globalMapping = {}
    if globalmap

      picked = []
      $cache.pkmn.keys.each { |species|
        # Ensure restricted mons stay restricted
        if @@settings.restrictedMons.include?(species)
          globalMapping.store(species, species)
          next
        end

        types = [@@pokemonCache[species, 0].Type1, @@pokemonCache[species, 0].Type2]
        pickList = @@encounterPool.dup
        # Filter out based on type first
        if typeThemed
          pickList.delete_if { |mon| !types.any? { |type| mon.types.include?(type) }}
        end

        pickList -= picked if pickList.length - picked.length > 0

        if pickList.length == 1
          pick = pickList[0]
        elsif similarBST
          pick = getSimilarTarget(species, pickList, picked)
        else
          pick = pickList.sample(random: rrandom)
        end

        globalMapping.store(species, pick)
        picked.push(pick)
      }

      # initialize the form mapping for later
      globalMapping.each { |species, mon|
        next if @@settings.restrictedMons.include?(species)
        next if @@pokemonCache[mon.species].forms[0] == mon.form
        formHash[species] = {} if !formHash[species]
        formHash[species][mon.species] = mon.form
      }
    end

    encounterTypes = EncounterTypes::Names.map { |enc| enc.to_sym }
    @@encounters.each { |map, table|
      encounterTypes.each { |enc|
        next if !table.keys.include?(enc)
        if globalmap
          table[enc].transform_keys! { |species|
            mon = globalMapping[species]

            # if not base form, push to form map
            if formHash[species]
              d = formHash[species]
              @@formHash[map] = {} if !@@formHash[map]
              @@formHash[map][mon.species] = [] if !@@formHash[map][mon.species]
              @@formHash[map][mon.species].push(d[mon.species])
            end

            globalMapping[species].species
          }
        else
          mapping = {}
          picked = []
          table[enc].keys.each { |species|
            # Ensure restricted mons stay restricted
            if @@settings.restrictedMons.include?(species)
              mapping.store(species, species)
              next
            end

            types = [@@pokemonCache[species, 0].Type1, @@pokemonCache[species, 0].Type2]
            pickList = @@encounterPool.dup
            # Filter out based on type first
            if typeThemed
              pickList.delete_if { |mon| !types.any? { |type| mon.types.include?(type) }}
            end

            pickList -= picked if pickList.length - picked.length > 0

            if pickList.length == 1
              pick = pickList[0]
            elsif similarBST
              pick = getSimilarTarget(species, pickList, picked)
            else
              pick = pickList.sample(random: rrandom)
            end

            mapping.store(species, pick)
            picked.push(pick)
          }

          table[enc].transform_keys! { |species|
            mon = mapping[species]

            # if not base form, push to form map
            if @@pokemonCache[mon.species].forms[0] != mon.form
              @@formHash[map] = {} if !@@formHash[map]
              @@formHash[map][mon.species] = [] if !@@formHash[map][mon.species]
              @@formHash[map][mon.species].push(mon.form)
            end

            mapping[species].species
          }
        end
        #p table
      }
    }
  end

  def self.randomizeStatics
    forceGrouping = @@settings.statics[:statics][:forceGrouping]

    pool = @@pokemonPool.find_all { |mon| !(RandomizerUtils.getMegaEvolutions.include?(mon) && !@@settings.misc[:allowMegas]) }
    picked = []
    if forceGrouping
      legendaryPool = pool.find_all { |mon| PBStuff::LEGENDARYLIST.include?(mon.species) }
      normalPool = pool - legendaryPool
      @@staticData.keys.each { |oldStatic|
        if @@settings.restrictedMons.include?(oldStatic)
          @@staticData[oldStatic] = nil
          next
        end
        if PBStuff::LEGENDARYLIST.include?(oldStatic)
          pick = legendaryPool.sample(random: rrandom)
        else
          pick = normalPool.sample(random: rrandom)
        end
        #ensure not picked
        while picked.include?(pick)
          if PBStuff::LEGENDARYLIST.include?(oldStatic)
            pick = legendaryPool.sample(random: rrandom)
          else
            pick = normalPool.sample(random: rrandom)
          end
        end

        @@staticData[oldStatic] = { species: pick.species, form: pick.formNumber }
        picked.push(pick)
      }
    else
      @@staticData.keys.each { |oldStatic|
        if @@settings.restrictedMons.include?(oldStatic)
          @@staticData[oldStatic] = nil
          next
        end
        pick = pool.sample(random: rrandom)
        while picked.include?(pick)
          pick = pool.sample(random: rrandom)
        end

        @@staticData[oldStatic] = { species: pick.species, form: pick.formNumber }
        picked.push(pick)
      }
    end

  end

  def self.randomizeStarters
    starterSettings = @@settings.statics[:starters]
    similarBST = starterSettings[:similarBST]
    forceThreeStage = starterSettings[:forceThreeStage]

    starterPool = @@encounterPool.dup
    starterPool.delete_if { |mon| !mon.isThreeStage?() } if forceThreeStage

    picked = []
    @@starterData.keys.each { |starter|
      if @@settings.restrictedMons.include?(starter)
        @@starterData[starter] = nil
        next
      end
      if similarBST
        pick = getSimilarTarget(starter, starterPool, picked)
      else
        pick = starterPool.sample(random: rrandom)
        # ensure pool has sufficient mons to guarantee unique starters
        while picked.include?(pick) && (starterPool - picked).length >= picked.length
          pick = starterPool.sample(random: rrandom)
        end
      end

      @@starterData[starter] = { species: pick.species, form: pick.formNumber }
      picked.push(pick)
    }
  end

  def self.getSimilarTarget(species, pickList, picked)
    # Want to check by 5% similarity each direction. Limit tries to 3?
    targetBST = @@pokemonCache[species, 0].BaseStats.sum
    minBST = targetBST - (targetBST / 20)
    maxBST = targetBST + (targetBST / 20)
    tries = 0
    canPick = []
    emergencyPicks = []
    while canPick.empty? || (canPick.length < 3 && tries < 3)
      pickList.each { |pokemon|
        if pokemon.bst <= maxBST && pokemon.bst >= minBST && !canPick.include?(pokemon) && !emergencyPicks.include?(pokemon)
          if picked.include?(pokemon)
            emergencyPicks.push(pokemon)
          else
            canPick.push(pokemon)
          end
        end
      }
      if tries >= 2 && canPick.empty?
        canPick += emergencyPicks
      end
      minBST -= (targetBST / 20)
      maxBST += (targetBST / 20)
      tries += 1
    end
    return canPick.sample(random: rrandom)
  end
#
end
