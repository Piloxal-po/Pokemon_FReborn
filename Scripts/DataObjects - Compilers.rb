def compileAll
  compileConnections
  compileMons
  compileMoves
  compileItems
  compileAbilities
  compileMapData
  compileMetadata
  compileFields
  compileFieldNotes if !Rejuv
  compileTypes
  compileTrainerTypes
  compileTrainers
  compileNatures
  compileBosses if Rejuv
  compileTownMap unless Desolation
  pbCompileTownMap if Desolation
  compileBTData if Reborn
  $cache = nil
  $cache = Cache_Game.new
end

def compileMons
  cprint "Reading montext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/montext.rb") { |f|
    eval(f.read)
  }
  cprint "done.\n"
  spacetoclear = 0
  mons = MonDataHash.new()
  MONHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"

    # Check for missing hidden ability definitions.
    i = 0
    value.each do |name, definition|
      i += 1
      break if i == 1 && definition[:HiddenAbility].nil?
      next if i == 1
      next unless name.instance_of?(String)
      next if definition[:Abilities].nil?
      next unless definition[:HiddenAbility].nil?
      puts key.to_s + " " + name + " is missing HiddenAbility and inherits it from base form."
      puts "Please define HiddenAbility explicitly. Use a standard ability value if no hidden should exist."
    end

    # Check for overriding only one type of dual-type base form
    i = 0
    value.each do |name, definition|
      i += 1
      break if i == 1 && definition[:Type2].nil?
      next if i == 1
      next unless name.instance_of?(String)
      next if definition[:Type1].nil?
      next unless definition[:Type2].nil?
      puts key.to_s + " " + name + " is missing Type2 and inherits it from base form."
      puts "Please define Type2 explicitly. Use Type1 value if this form should be single type."
    end

    mons[key] = MonWrapper.new(key, value)
  }
  cprint "Compiled data for mons.dat#{" " * spacetoclear}\n"
  save_data(mons, "Data/mons.dat")
  cprint "Saved mons.dat\n\n"
  if $Trainer
    $Trainer.pokedex.refreshDex
  end
end

def compileMoves
  cprint "Reading movetext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/movetext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  moves = {}
  spacetoclear = 0
  MOVEHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    moves[key] = MoveData.new(key, value)
  }
  cprint "Compiled data for moves.dat#{" " * spacetoclear}\n"
  save_data(moves, "Data/moves.dat")
  cprint "Saved moves.dat\n\n"
end

def compileItems
  cprint "Reading itemtext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/itemtext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  items = {}
  spacetoclear = 0
  ITEMHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    items[key] = ItemData.new(key, value)
  }
  $PokemonBag.reQuantity() if $PokemonBag
  cprint "Compiled data for items.dat#{" " * spacetoclear}\n"
  save_data(items, "Data/items.dat")
  cprint "Saved items.dat\n\n"
end

def compileAbilities
  cprint "Reading abiltext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/abiltext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  abilities = {}
  spacetoclear = 0
  ABILHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    abilities[key] = AbilityData.new(key, value)
  }
  cprint "Compiled data for abil.dat#{" " * spacetoclear}\n"
  save_data(abilities, "Data/abil.dat")
  cprint "Saved abil.dat\n\n"
  if $cache
    $cache.cacheAbilities
  end
end

def compileMapData
  cprint "Reading enctext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/enctext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  cprint "Reading metatext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/metatext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  mapdata = []
  spacetoclear = 0
  for i in 1...1000 # rmxp's classic map limit
    encdata = ENCHASH[i]
    metadata = METAHASH[i]
    next if !metadata

    # Add SurfaceMap metadata
    for j in 1...1000
      meta = METAHASH[j]
      next if !meta
      if meta[:DiveMap] == i
        metadata[:SurfaceMap] = j
      end
    end

    spacetoclear = i.to_s.length
    cprint "Compiling data for #{i}#{" " * spacetoclear}\r"
    mapdata[i] = MapMetadata.new(i, encdata, metadata)
  end
  cprint "Compiled data for maps.dat#{" " * spacetoclear}\n"
  save_data(mapdata, "Data/maps.dat")
  cprint "Saved maps.dat\n\n"
  if $game_map
    $game_map.need_refresh = true
  end
end

def compileTownMap
  return if Desolation

  cprint "Reading townmap.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/townmap.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  townmap = {}
  spacetoclear = 0
  for i in 0...TOWNMAP.length
    spacetoclear = TOWNMAP[i][:name].to_s.length
    cprint "Compiling data for #{TOWNMAP[i][:name]}#{" " * spacetoclear}\r"
    region = TOWNMAP[i]
    townmap[i] = {}
    townmap[i][:name] = region[:name]
    townmap[i][:filename] = region[:filename]
    region[:points].each { |point, data|
      townmap[point] = TownMapData.new(point, data, i)
      # This block sets healingSpot to the flyPoint as soon as you enter a map which has a flyPoint.
      # Which breaks Teleport in Reborn - healingSpot should be set when you enter Belrose Manse, not when you enter Tanzan Cove.
      if !data[:flyData].empty? && Rejuv
        # puts "#{i}: #{point.inspect}"
        flyData = data[:flyData]
        $cache.mapdata[flyData[0]].syncMapData(i, point, flyData)
      end
    }
  end
  cprint "Compiled data for townmap.dat#{" " * spacetoclear}\n"
  save_data(townmap, "Data/townmap.dat")
  save_data($cache.mapdata, "Data/maps.dat") if Rejuv
  cprint "Saved townmap.dat\n\n"
end

def compileMetadata
  cprint "Reading metatext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/metatext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  spacetoclear = 0
  players = []
  METAHASH.each { |key, value|
    next if key.is_a?(Integer)

    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    players.push(METAHASH[key]) if key.to_s.include?("player")
  }
  meta = {}
  meta[:home]             = METAHASH[:home]
  meta[:TrainerVictory]   = METAHASH[:TrainerVictory]
  meta[:WildVictory]      = METAHASH[:WildVictory]
  meta[:TrainerBattle]    = METAHASH[:TrainerBattle]
  meta[:WildBattle]       = METAHASH[:WildBattle]
  meta[:Surf]             = METAHASH[:Surf]
  meta[:LavaSurf] = METAHASH[:LavaSurf]
  meta[:Bicycle]          = METAHASH[:Bicycle]
  meta[:Players]          = players
  cprint "Compiled data for meta.dat#{" " * spacetoclear}\n"
  save_data(meta, "Data/meta.dat")
  cprint "Saved meta.dat\n\n"
end

def compileTypes
  cprint "Reading typetext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/typetext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  types = {}
  spacetoclear = 0
  TYPEHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    types[key] = TypeData.new(key, value)
  }
  cprint "Compiled data for data for types.dat#{" " * spacetoclear}\n"
  save_data(types, "Data/types.dat")
  cprint "Saved types.dat\n\n"
end

def compileTrainerTypes
  cprint "Reading ttypetext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/ttypetext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  ttypes = {}
  spacetoclear = 0
  TTYPEHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    ttypes[key] = TrainerData.new(key, value)
  }
  cprint "Compiled data for ttypes.dat#{" " * spacetoclear}\n"
  save_data(ttypes, "Data/ttypes.dat")
  cprint "Saved ttypes.dat\n\n"
end

def compileTrainers
  cprint "Reading trainertext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/trainertext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  # it's really more like "assembling" them but w/e
  fulltrainerdata = {}
  spacetoclear = 0
  # iterate through, sort teams into hashes
  for trainer in TEAMARRAY
    next if trainer.nil?

    spacetoclear = trainer[:teamid].inspect.length
    cprint "Compiling data for #{trainer[:teamid].inspect}#{" " * spacetoclear}\r"
    # split trainer into important components
    trainertype = trainer[:teamid][1]
    name = trainer[:teamid][0]
    items = trainer[:items]
    pkmn = trainer[:mons]
    for mon in pkmn
      unless $cache.pkmn[mon[:species]].hasForm?(mon[:form])
        puts trainer[:teamid].to_s + " is using unknown " + mon[:species].to_s + " form " + mon[:form].to_s
        # Note: It is recommended to add cosmetic-only forms such as Furfrou into montext when used by trainers.
      end
    end
    partyid = trainer[:teamid][2]
    ace = trainer[:ace]
    defeat = trainer[:defeat]
    trainereffect = trainer[:trainereffect]
    # see if there's a trainer with the same type/name in the hash already
    fulltrainerdata[trainertype] = {} if !fulltrainerdata[trainertype]
    fulltrainerdata[trainertype][name] = [] if !fulltrainerdata[trainertype][name]
    fulltrainerdata[trainertype][name].push([partyid, pkmn, items, ace, defeat, trainereffect])
  end
  cprint "Compiled data for trainers.dat#{" " * spacetoclear}\n"
  save_data(fulltrainerdata, "Data/trainers.dat")
  cprint "Saved trainers.dat\n\n"
end

def compileBosses
  bossdata = {}
  cprint "Reading mapconnections.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/BossInfo.rb") { |f| eval(f.read) }
  cprint "done\n"
  spacetoclear = 0
  BOSSINFOHASH.each { |boss, data|
    spacetoclear = boss.to_s.length
    cprint "Compiling data for #{boss}#{" " * spacetoclear}\r"
    bossdata[boss] = BossData.new(boss, data)
  }
  cprint "Compiled data for bossdata.dat#{" " * spacetoclear}\n"
  save_data(bossdata, "Data/bossdata.dat")
  cprint "Saved bossdata.dat\n\n"
end

def compileConnections
  cprint "Reading mapconnections.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/mapconnections.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  connections = {}
  spacetoclear = 0
  MAPCONNECTIONSHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    connections[key] = value
  }
  connections = MapFactoryHelper.processConnections(connections)
  cprint "Compiled data for connections.dat#{" " * spacetoclear}\n"
  save_data(connections, "Data/connections.dat")
  cprint "Saved connections.dat\n\n"
end

def compileFields
  fields = {}
  cprint "Reading fieldtext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/fieldtext.rb") { |f| eval(f.read) }
  cprint "done\n"

  FIELDEFFECTS[nil] = FIELDEFFECTS[:INDOOR].clone
  FIELDEFFECTS[0] = FIELDEFFECTS[:INDOOR].clone
  spacetoclear = 0

  FIELDEFFECTS.each { |key, data|
    spacetoclear = key.to_s.length if key != nil && key != 0
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    currentfield = FEData.new
    # Basic data copying
    currentfield.name = data[:name]
    currentfield.fieldAppSwitch = data[:fieldAppSwitch]
    currentfield.message = data[:fieldMessage]
    currentfield.secretPower = data[:secretPower]
    currentfield.graphic = data[:graphic]
    currentfield.naturePower = data[:naturePower]
    currentfield.mimicry = data[:mimicry]
    currentfield.statusMods = data[:statusMods]
    currentfield.overlayStatusMods = data[:overlay][:statusMods] if data[:overlay]
    # now for worse shit
    # invert hashes such that move => mod
    movetypemod = pbHashForwardizer(data[:typeMods]) || {}
    movedamageboost = pbHashForwardizer(data[:damageMods]) || {}
    moveaccuracyboost = pbHashForwardizer(data[:accuracyMods]) || {}
    moveeffects = pbHashForwardizer(data[:moveEffects]) || {}
    typedamageboost = pbHashForwardizer(data[:typeBoosts]) || {}
    typetypemod = pbHashForwardizer(data[:typeAddOns]) || {}
    fieldchange = pbHashForwardizer(data[:fieldChange]) || {}
    changeeffects = pbHashForwardizer(data[:changeEffects]) || {}
    typecondition = data[:typeCondition] ? data[:typeCondition] : {}
    typeeffects = data[:typeEffects] ? data[:typeEffects] : {}
    changecondition = data[:changeCondition] ? data[:changeCondition] : {}
    dontchangebackup = data[:dontChangeBackup] ? data[:dontChangeBackup] : {}
    if data[:overlay]
      overlaydamage = pbHashForwardizer(data[:overlay][:damageMods]) || {}
      overlaytypemod = pbHashForwardizer(data[:overlay][:typeMods]) || {}
      overlaytypeboost = pbHashForwardizer(data[:overlay][:typeBoosts]) || {}
      overlaytypecons = data[:overlay][:typeCondition] ? data[:overlay][:typeCondition] : {}
    end

    # messages get stored separately and are replaced by an index
    movemessages  = data[:moveMessages]  || {}
    typemessages  = data[:typeMessages]  || {}
    changemessage = data[:changeMessage] || {}
    overlaymovemsg = data[:overlay][:moveMessages] || {} if data[:overlay]
    overlaytypemsg = data[:overlay][:typeMessages] || {} if data[:overlay]
    movemessagelist = []
    typemessagelist = []
    changemessagelist = []
    olmovemessagelist = []
    oltypemessagelist = []
    messagearray = [movemessages, typemessages, changemessage]
    messagearray = [movemessages, typemessages, changemessage, overlaymovemsg, overlaytypemsg] if data[:overlay]
    messagearray.each_with_index { |hashdata, index|
      messagelist = hashdata.keys
      newhashdata = {}
      hashdata.each { |key, value|
        newhashdata[messagelist.index(key) + 1] = value
      }
      invhash = pbHashForwardizer(newhashdata)
      case index
        when 0
          movemessagelist = messagelist
          movemessages = invhash
        when 1
          typemessagelist = messagelist
          typemessages = invhash
        when 2
          changemessagelist = messagelist
          changemessage = invhash
        when 3
          olmovemessagelist = messagelist
          overlaymovemsg = invhash
        when 4
          oltypemessagelist = messagelist
          overlaytypemsg = invhash
      end
    }

    # now we have all our hashes de-backwarded, and can fuse them all together.
    # first, moves:
    # get all the keys in one place
    keys = (movedamageboost.keys << movetypemod.keys << moveaccuracyboost.keys << moveeffects.keys << fieldchange.keys).flatten
    # now we take all the old hashes and squish them into one:
    fieldmovedata = {}
    for move in keys
      movedata = {}
      movedata[:mult] = movedamageboost[move] if movedamageboost[move]
      movedata[:typemod] = movetypemod[move] if movetypemod[move]
      movedata[:accmod] = moveaccuracyboost[move] if moveaccuracyboost[move]
      movedata[:multtext] = movemessages[move] if movemessages[move]
      movedata[:moveeffect] = moveeffects[move] if moveeffects[move]
      movedata[:fieldchange] = fieldchange[move] if fieldchange[move]
      movedata[:changetext] = changemessage[move] if changemessage[move]
      movedata[:changeeffect] = changeeffects[move] if changeeffects[move]
      movedata[:dontchangebackup] = dontchangebackup.include?(move)
      fieldmovedata[move] = movedata
    end
    # now, types!
    fieldtypedata = {}
    keys = (typedamageboost.keys << typetypemod.keys << typeeffects.keys).flatten
    for type in keys
      typedata = {}
      typedata[:mult] = typedamageboost[type] if typedamageboost[type]
      typedata[:typemod] = typetypemod[type] if typetypemod[type]
      typedata[:typeeffect] = typeeffects[type] if typeeffects[type]
      typedata[:multtext] = typemessages[type] if typemessages[type]
      typedata[:condition] = typecondition[type] if typecondition[type]
      fieldtypedata[type] = typedata
    end
    if data[:overlay]
      overlaymovedata = {}
      keys = (overlaydamage.keys << overlaytypemod.keys).flatten
      for move in keys
        movedata = {}
        movedata[:mult] = overlaydamage[move] if overlaydamage[move]
        movedata[:typemod] = overlaytypemod[move] if overlaytypemod[move]
        movedata[:multtext] = overlaymovemsg[move] if overlaymovemsg[move]
        overlaymovedata[move] = movedata
      end
      overlaytypedata = {}
      keys = overlaytypeboost.keys
      for type in keys
        typedata = {}
        typedata[:mult] = overlaytypeboost[type] if overlaytypeboost[type]
        typedata[:multtext] = overlaytypemsg[type] if overlaytypemsg[type]
        typedata[:condition] = overlaytypecons[type] if overlaytypecons[type]
        overlaytypedata[type] = typedata
      end
    end

    # seeds for good measure.
    seeddata = {}
    seeddata = data[:seed]
    currentfield.fieldtypedata = fieldtypedata
    currentfield.fieldmovedata = fieldmovedata
    currentfield.seeddata = seeddata
    currentfield.movemessagelist = movemessagelist
    currentfield.typemessagelist = typemessagelist
    currentfield.changemessagelist = changemessagelist
    currentfield.fieldchangeconditions = changecondition
    currentfield.overlaytypedata = overlaytypedata if overlaytypedata
    currentfield.overlaymovedata = overlaymovedata if overlaymovedata
    currentfield.overlaymovemessagelist = olmovemessagelist if olmovemessagelist
    currentfield.overlaytypemessagelist = oltypemessagelist if oltypemessagelist
    # all done!
    fields.store(key, currentfield)
  }
  cprint "Compiled data for fields.dat#{" " * spacetoclear}\n"
  save_data(fields, "Data/fields.dat")
  cprint "Saved fields.dat\n\n"
end

def compileNatures
  cprint "Reading naturetext.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/naturetext.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  natures = {}
  spacetoclear = 0
  NATUREHASH.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    natures[key] = NatureData.new(key, value)
  }
  cprint "Compiled data for natures.dat#{" " * spacetoclear}\n"
  save_data(natures, "Data/natures.dat")
  cprint "Saved natures.dat\n\n"
end

def compileAnimations
  cprint "Reading PkmnAnimations.rxdata..."
  begin
    pbanims = load_data("Data/PkmnAnimations.rxdata")
  rescue
    pbanims = PBAnimations.new
  end
  cprint "done\n"
  move2anim = [{}, {}]
  spacetoclear = 0
  for i in 0...pbanims.length
    next if !pbanims[i]

    spacetoclear = pbanims[i].name.length
    cprint "Compiling data for #{pbanims[i].name}#{" " * spacetoclear}\r"
    if pbanims[i].name[/^OppMove\:\s*(.*)$/]
      if $cache.moves.key?(pbanims[i].name.split(":")[1].intern)
        moveid = pbanims[i].name.split(":")[1].intern
        move2anim[1][moveid.intern] = i
      end
    elsif pbanims[i].name[/^Move\:\s*(.*)$/]
      if $cache.moves.key?(pbanims[i].name.split(":")[1].intern)
        moveid = pbanims[i].name.split(":")[1].intern
        move2anim[0][moveid.intern] = i
      end
    end
  end
  cprint "Compiled data for PkmnAnimations.rxdata and move2anim.dat#{" " * spacetoclear}\n"
  save_data(move2anim, "Data/move2anim.dat")
  cprint "Saved move2anim.dat\n\n"
  save_data(pbanims, "Data/PkmnAnimations.rxdata")
  cprint "Saved PkmnAnimations.rxdata\n\n"
  animExpander
end

def animExpander
  for i in 0...$cache.animations.length
    for j in 1...$cache.animations[i].length
      for k in 0...$cache.animations[i][j].length
        if $cache.animations[i][j][k] == 0
          $cache.animations[i][j][k] = $cache.animations[i][j - 1][k].clone
        end
      end
    end
  end
end

def compileBTData
  return if !Reborn

  compileBTMons
  compileBTTrainers
end

def compileBTMons
  cprint "Reading btpokemon.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/btpokemon.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  btmons = {}
  spacetoclear = 0
  BTMONS.each { |key, value|
    spacetoclear = key.to_s.length
    cprint "Compiling data for #{key}#{" " * spacetoclear}\r"
    PBDebug.log("Compiling data for #{key}#{" " * spacetoclear}\r")
    btmons[key] = []
    for set in value
      set[:species] = key
      btmons[key].push(BTPokemon.new(set))
    end
  }
  cprint "Compiled data for btmons.dat#{" " * spacetoclear}\n"
  save_data(btmons, "Data/btmons.dat")
  cprint "Saved btmons.dat\n\n"
end

def compileBTTrainers
  cprint "Reading bttrainers.rb..."
  File.open("Scripts/" + GAMEFOLDER + "/bttrainers.rb") { |f|
    eval(f.read)
  }
  cprint "done\n"
  bttrainers = []
  spacetoclear = 0
  BTTRAINERS.each { |data|
    # spacetoclear = data[:tclass].to_s.length + data[:name].length + 1
    cprint "Compiling data for #{data[:tclass]} #{data[:name]}#{" " * 10}\r"
    if data[:monIndexes].length < 4
      raise "Less than 4 mons on facility trainer #{data[:tclass]} #{data[:name]}"
    end

    for mon in data[:monIndexes]
      if !BTMONS.keys.include?(mon)
        raise "No sets for #{mon} on facility trainer #{data[:tclass]} #{data[:name]}"
        return
      end
    end
    bttrainers.push(BTTrainerData.new(data))
  }
  cprint "Compiled data for bttrainers.dat#{" " * spacetoclear}\n"
  save_data(bttrainers, "Data/bttrainers.dat")
  cprint "Saved bttrainers.dat\n\n"
end
