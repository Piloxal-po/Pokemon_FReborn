
def debugCompileAll
  lang = choiceLanguage
  debugCompileMessagesWithLang(lang)
  debugCompileMovesWithLang(lang)
  debugCompileAbilitiesWithLang(lang)
  debugCompileItemsWithLang(lang)
  debugCompileMonsWithLang(lang)
  debugCompileNaturesWithLang(lang)
  debugCompileMapInfosWithLang(lang)
  debugCompileTrainersWithLang(lang)
  debugCompileFieldsWithLang(lang)
  debugCompileFieldNotesWithLang(lang)
end

def denormalizeData(text)
  if text.start_with?("[]")
    line = text.clone.gsub(/\[\]/, "")
    if line.to_i.to_s == line
      return line
    end
  end
  return text
end

def buildData(file, skipEmptyLine = true)
  res = {}
  type = 0
  id = 0
  iLine = 0
  dataFile = File.open(file)
  l = nil
  begin
    dataFile.each_line { |line| 
      line = line.strip
      l = line
      if line == "[1]" # name
        type = 1
      elsif line == "[2]" # description
        type = 2
      elsif line == "[3]" # description
        type = 3
      elsif skipEmptyLine && line.empty? # empty line
      elsif line.to_i.to_s == line # check if ID
        id = line.to_i
        iLine = 1
      elsif iLine % 2 != 0 # first line skip
        iLine += 1
      elsif type == 1 && res[id] && iLine % 2 == 0
        val = res[id][0]
        if val.instance_of? Array
          val.push(denormalizeData(line))
        else
          val = [val, denormalizeData(line)]
        end
        res[id] = [val, res[id][1], res[id][2]]
        iLine += 1
      elsif type == 2 && res[id][1] && iLine % 2 == 0
        val = res[id][1]
        if val.instance_of? Array
          val.push(denormalizeData(line))
        else
          val = [val, denormalizeData(line)]
        end
        res[id] = [res[id][0], val, res[id][2]]
        iLine += 1
      elsif type == 3 && res[id][2] && iLine % 2 == 0
        val = res[id][2]
        if val.instance_of? Array
          val.push(denormalizeData(line))
        else
          val = [val, denormalizeData(line)]
        end
        res[id] = [res[id][0], res[id][1], val]
        iLine += 1
      elsif type == 1 # name = init array
        res[id] = [denormalizeData(line), nil, nil]
        iLine += 1
      elsif type == 2 # description = update array
        res[id] = [res[id][0], denormalizeData(line), res[id][2]]
        iLine += 1
      elsif type == 3 # description = update array
        res[id] = [res[id][0], res[id][1], denormalizeData(line)]
        iLine += 1
      end
    }
  rescue => e
    Kernel.pbMessage(l)
    raise pbGetExceptionMessage(e)
  end
  return res
end

def debugCompileMoves
  debugCompileMovesWithLang(choiceLanguage)
end

def debugCompileMovesWithLang(lang)
    File.open("Scripts/" + GAMEFOLDER + "/movetext.rb") { |f|
      eval(f.read)
    }
    dir = DIR_I18N + lang
    debugMkdir(dir)
    dict = buildData(DIR_DEBUG_I18N + lang + "/" + MOVES_FILE + ".txt")
    moves = {}
    MOVEHASH.each { |key, value|
      if dict[value[:ID].to_i]
        value[:name] = dict[value[:ID].to_i][0]
        value[:desc] = dict[value[:ID].to_i][1]
      end
      moves[key] = MoveData.new(key, value)
    }
    save_data(moves, dir + "/" + MOVES_FILE + ".dat")
end

def debugCompileAbilities
  debugCompileAbilitiesWithLang(choiceLanguage)
end

def debugCompileAbilitiesWithLang(lang)
  File.open("Scripts/" + GAMEFOLDER + "/abiltext.rb") { |f|
    eval(f.read)
  }
  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + ABILITIES_FILE + ".txt")
  abilities = {}
  ABILHASH.each { |key, value|
    if dict[value[:ID].to_i]
      value[:name] = dict[value[:ID].to_i][0]
      value[:desc] = dict[value[:ID].to_i][1]
    end
    abilities[key] = AbilityData.new(key, value)
  }
  save_data(abilities, dir + "/" + ABILITIES_FILE + ".dat")
end

def debugCompileMessages
  debugCompileMessagesWithLang(choiceLanguage)
end

def debugCompileMessagesWithLang(lang)
  dir = DIR_I18N + lang
  debugMkdir(dir)
  outfile = File.open(dir + "/" + MESSAGE_FILE + ".dat", "wb")
  begin
    intldat = pbGetText(DIR_DEBUG_I18N + lang + "/" + MESSAGE_FILE + ".txt")
    Marshal.dump(intldat, outfile)
  rescue => e
    Kernel.pbMessage(pbGetExceptionMessage(e))
  ensure
    outfile.close
  end
end

def debugCompileItems
  debugCompileItemsWithLang(choiceLanguage)
end

def debugCompileItemsWithLang(lang)
  File.open("Scripts/" + GAMEFOLDER + "/itemtext.rb") { |f|
    eval(f.read)
  }
  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + ITEM_FILE + ".txt")
  moves = {}
  ITEMHASH.each { |key, value|
    if dict[value[:ID].to_i]
      value[:name] = dict[value[:ID].to_i][0]
      value[:desc] = dict[value[:ID].to_i][1]
    end
    moves[key] = ItemData.new(key, value)
  }
  save_data(moves, dir + "/" + ITEM_FILE + ".dat")
end

def debugCompileMons
  debugCompileMonsWithLang(choiceLanguage)
end

def debugCompileMonsWithLang(lang)
  File.open("Scripts/" + GAMEFOLDER + "/montext.rb") { |f|
    eval(f.read)
  }
  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + MONS_FILE + ".txt")
  mons = MonDataHash.new()
  begin
    MONHASH.each { |key, value|
      iName = 0
      iDescription = 0
      iType = 0
      id = 0
      value.each do |name, definition|
        if definition.instance_of? Hash
          if definition[:dexnum]
            id = definition[:dexnum]
            if dict[id][0].instance_of? Array
              definition[:name] = dict[id][0][iName]
              iName += 1
            else
              definition[:name] = dict[id][0]
            end
            if dict[id][1].instance_of? Array
              definition[:dexentry] = dict[id][1][iDescription]
              iDescription += 1
            else
              definition[:dexentry] = dict[id][1]
            end
            if dict[id][2].instance_of? Array
              definition[:kind] = dict[id][2][iType]
              iType += 1
            else
              definition[:kind] = dict[id][2]
            end
          elsif definition[:name] && definition[:dexentry] && definition[:kind]
            definition[:name] = dict[id][0][iName]
            iName += 1
            definition[:dexentry] = dict[id][1][iDescription]
            iDescription += 1
            definition[:kind] = dict[id][2][iType]
            iType += 1
          elsif definition[:name] && definition[:dexentry]
            definition[:name] = dict[id][0][iName]
            iName += 1
            definition[:dexentry] = dict[id][1][iDescription]
            iDescription += 1
          elsif definition[:name] && definition[:kind]
            definition[:name] = dict[id][0][iName]
            iName += 1
            definition[:kind] = dict[id][2][iType]
            iType += 1
          elsif definition[:kind] && definition[:dexentry]
            definition[:kind] = dict[id][2][iType]
            iType += 1
            definition[:dexentry] = dict[id][1][iDescription]
            iDescription += 1
          elsif definition[:name]
            definition[:name] = dict[id][0][iName]
            iName += 1
          elsif definition[:dexentry]
            definition[:dexentry] = dict[id][1][iDescription]
            iDescription += 1
          elsif definition[:kind]
            definition[:kind] = dict[id][2][iType]
            iType += 1
          end
        end
      end
      mons[key] = MonWrapper.new(key, value)
    }
  rescue => e
    Kernel.pbMessage(pbGetExceptionMessage(e))
  end
  save_data(mons, dir + "/" + MONS_FILE + ".dat")
end

def debugCompileNatures
  debugCompileNaturesWithLang(choiceLanguage)
end

def debugCompileNaturesWithLang(lang)
  File.open("Scripts/" + GAMEFOLDER + "/naturetext.rb") { |f|
    eval(f.read)
  }
  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + NATURE_FILE + ".txt")
  natures = {}
  i = 0
  NATUREHASH.each { |key, value|
    value[:name] = dict[i.to_i][0]
    natures[key] = NatureData.new(key, value)
    i += 1
  }
  save_data(natures, dir + "/" + NATURE_FILE + ".dat")
end

def debugCompileMapInfos
  debugCompileMapInfosWithLang(choiceLanguage)
end

def debugCompileMapInfosWithLang(lang)
  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + MAP_INFO_FILE + ".txt")
  mapInfo = $cache.mapinfos.clone
  mapInfo.each { |key, value|
    if value.name
      value.name = dict[key][0]
    end
  }
  save_data(mapInfo, dir + "/" + MAP_INFO_FILE + ".dat")
end

def debugCompileTrainers
  debugCompileTrainersWithLang(choiceLanguage)
end

def debugCompileTrainersWithLang(lang)
  File.open("Scripts/" + GAMEFOLDER + "/trainertext.rb") { |f|
    eval(f.read)
  }
  File.open("Scripts/" + GAMEFOLDER + "/montext.rb") { |f|
    eval(f.read)
  }
  File.open("Scripts/" + GAMEFOLDER + "/movetext.rb") { |f|
      eval(f.read)
  }
  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + TRAINER_FILE + ".txt")
  
  fulltrainerdata = {}
  i = 1
  for trainer in TEAMARRAY
    next if trainer.nil?
    # split trainer into important components
    trainertype = trainer[:teamid][1]
    name = trainer[:teamid][0]
    items = trainer[:items]
    pkmn = trainer[:mons]
    customEntity = dict[i]
    customName = (customEntity[0][0] && !customEntity[0][0].empty?) ? customEntity[0][0] : name
    iMon = 1
    split = customEntity[0][1].split(",")
    if !MONHASH[split[0].to_sym]
      trainer[:defeat] = customEntity[0][1]
      iMon = 2

    end
    j = 0
    if customEntity[0][iMon]
      pkmn.each {|value| 
        customMonInformation = customEntity[0][j + iMon].split(",")
        value[:species] = customMonInformation[0].to_sym if (customMonInformation[0] && !customMonInformation[0].empty?)
        value[:level] = customMonInformation[1].to_i if (customMonInformation[1] && !customMonInformation[1].empty?)
        value[:item] = customMonInformation[2].to_sym if (customMonInformation[2] && !customMonInformation[2].empty?)
        if customMonInformation[3] && !customMonInformation[3].empty?
          customMonMoves = customMonInformation[3].split("|")
          if !customMonMoves[3]
            customMonMoves[3] = nil
          end
          value[:moves] = customMonMoves.map{|move| move ? move.to_sym : nil}
        end
        value[:gender] = customMonInformation[4] if (customMonInformation[4] && !customMonInformation[4].empty?)
        value[:ability] = customMonInformation[5].to_sym if (customMonInformation[5] && !customMonInformation[5].empty?)
        value[:nature] = customMonInformation[6].to_sym if (customMonInformation[6] && !customMonInformation[6].empty?)
        value[:name] = customMonInformation[7] if (customMonInformation[7] && !customMonInformation[7].empty?)
        if customMonInformation[8] && !customMonInformation[8].empty?
          value[:ev] = customMonInformation[8].split("|").map{|ev| ev ? ev.to_i : 0}
        end
        j += 1
      }
    end    
    partyid = trainer[:teamid][2]
    ace = trainer[:ace]
    defeat = trainer[:defeat]
    trainereffect = trainer[:trainereffect]
    # see if there's a trainer with the same type/name in the hash already
    fulltrainerdata[trainertype] = {} if !fulltrainerdata[trainertype]
    fulltrainerdata[trainertype][name] = [] if !fulltrainerdata[trainertype][name]
    fulltrainerdata[trainertype][name].push([partyid, pkmn, items, ace, defeat, trainereffect, customName])
    i += 1
  end
  save_data(fulltrainerdata, dir + "/" + TRAINER_FILE + ".dat")
end

def debugCompileFields
  debugCompileFieldsWithLang(choiceLanguage)
end

def debugCompileFieldsWithLang(lang)
  fields = {}
  File.open("Scripts/" + GAMEFOLDER + "/fieldtext.rb") { |f| eval(f.read) }

  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + FIELD_FILE + ".txt", false)

  FIELDEFFECTS[nil] = FIELDEFFECTS[:INDOOR].clone
  FIELDEFFECTS[0] = FIELDEFFECTS[:INDOOR].clone

  i = 1
  FIELDEFFECTS.each { |key, data|
    key2 = key && key != 0 ? key : :INDOOR
    customField = i > dict.length ? dict[1] : dict[i]

    currentfield = FEData.new
    # Basic data copying
    currentfield.name = customField[0][1] ? customField[0][1] : data[:name]
    currentfield.fieldAppSwitch = data[:fieldAppSwitch]
    currentfield.message = customField[1][0] ? customField[1][0].split("|") : data[:fieldMessage]
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
    movemessages = data[:moveMessages]  || {}
    if customField[1][1]
      j = 0
      fieldMessageArray = customField[1][1].split("|")
      movemessages = movemessages.reduce({}) do |acc, (key, value)|
        acc[fieldMessageArray[j]] = value
        j += 1
        acc
      end
    end
    typemessages  = data[:typeMessages]  || {}
    if customField[1][2]
      j = 0
      fieldMessageArray = customField[1][2].split("|")
      typemessages = typemessages.reduce({}) do |acc, (key, value)|
        acc[fieldMessageArray[j]] = value
        j += 1
        acc
      end
    end
    changemessage = data[:changeMessage] || {}
    if customField[1][3]
      j = 0
      fieldMessageArray = customField[1][3].split("|")
      changemessage = changemessage.reduce({}) do |acc, (key, value)|
        acc[fieldMessageArray[j]] = value
        j += 1
        acc
      end
    end
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
    seeddata[:message] = customField[1][4] if customField[1][4]
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
    i += 1
  }
  save_data(fields, dir + "/" + FIELD_FILE + ".dat")
end

def debugCompileFieldNotes
  return debugCompileFieldNotesWithLang(choiceLanguage)
end


def debugCompileFieldNotesWithLang(lang)
  quakemovenames = PBFields::QUAKEMOVES.map { |id| getMoveName(id) }.sort.join(", ")
  File.open("Scripts/" + GAMEFOLDER + "/fieldtext.rb") { |f| eval(f.read) }
  File.open("Scripts/" + GAMEFOLDER + "/fieldnotetext.rb") { |f| eval(f.read) }

  dir = DIR_I18N + lang
  debugMkdir(dir)
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + FIELD_NOTE_FILE + ".txt", false)
  all_field_notes = []
  i = 1
  FIELDNOTEEFFECTS.each { |value|
    v = value.clone
    v.text = dict[i][0][0] if (dict[i][0][0] and !dict[i][0][0].empty?)
    v.elaboration = dict[i][0][1] if (dict[i][0][1] and !dict[i][0][1].empty?)
    v.cogwheeltext = dict[i][0][2] if (dict[i][0][2] and !dict[i][0][2].empty?)
    all_field_notes.push(v)
    i += 1
  }

  File.open(dir + "/" + FIELD_NOTE_FILE + ".dat", "wb") { |file|
    Marshal.dump(all_field_notes, file)
  }
end