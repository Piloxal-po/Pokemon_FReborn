
def debugCompileAll
  lang = choiceLanguage
  debugCompileMovesWithLang(lang)
  debugCompileAbilitiesWithLang(lang)
  debugCompileMessagesWithLang(lang)
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
    dict = buildData(DIR_DEBUG_I18N + lang + "/" + MOVES_FILE + ".txt",)
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
  dict = buildData(DIR_DEBUG_I18N + lang + "/" + ABILITIES_FILE + ".txt",)
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
  rescue
    raise
  ensure
    outfile.close
  end
end

def buildData(file)
  res = {}
  name = false
  id = 0
  en = false
  dataFile = File.open(file)
  dataFile.each_line { |line| 
    line = line.strip
    if line == "[1]" # name
      name = true
    elsif line == "[2]" # description
      name = false
    elsif line.empty? # empty line
    elsif line.to_i.to_s == line # check if ID
      id = line.to_i
      en = true
    elsif en # first line skip
      en = false
    elsif name # name = init array
      res[id] = [line, ""]
    elsif !name # description = update array
      res[id] = [res[id][0], line]
    end
  }
  return res
end