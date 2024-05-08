
def debugCompileAll
  lang = choiceLanguage
  debugCompileMessagesWithLang(lang)
  debugCompileMovesWithLang(lang)
  debugCompileAbilitiesWithLang(lang)
  debugCompileItemsWithLang(lang)
  debugCompileMonsWithLang(lang)
  debugCompileNaturesWithLang(lang)
  debugCompileMapInfosWithLang(lang)
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
  spacetoclear = 0
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

def buildData(file)
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
      elsif line.empty? # empty line
      elsif line.to_i.to_s == line # check if ID
        id = line.to_i
        iLine = 1
      elsif iLine % 2 != 0 # first line skip
        iLine += 1
      elsif type == 1 && res[id] && iLine % 2 == 0
        res[id] = [[res[id][0]].concat([line]), res[id][1], res[id][2]]
        iLine += 1
      elsif type == 2 && res[id][1] && iLine % 2 == 0
        res[id] = [res[id][0], [res[id][1]].concat([line]), res[id][2]]
        iLine += 1
      elsif type == 3 && res[id][2] && iLine % 2 == 0
        res[id] = [res[id][0], res[id][1], [res[id][2]].concat([line])]
        iLine += 1
      elsif type == 1 # name = init array
        res[id] = [line, nil, nil]
        iLine += 1
      elsif type == 2 # description = update array
        res[id] = [res[id][0], line, res[id][2]]
        iLine += 1
      elsif type == 3 # description = update array
        res[id] = [res[id][0], res[id][1], line]
        iLine += 1
      end
    }
  rescue => e
    Kernel.pbMessage(pbGetExceptionMessage(e))
    Kernel.pbMessage(l)
  end
  return res
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