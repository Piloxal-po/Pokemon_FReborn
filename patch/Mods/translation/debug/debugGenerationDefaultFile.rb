def generateDebugTranslationModFile
    lang = choiceLanguage
    dir = DIR_DEBUG_I18N + lang
    debugMkdir(dir)
    t1 = Thread.new{generateMessageDebugTranslationFile(dir)}
    t2 = Thread.new{generateDebugTranslationModFileWithoutMessage(lang, dir)}
    t1.join()
    t2.join()
end

def generateDebugTranslationModFileWithoutMessage(lang, dir)
   generateAbilityDebugTranslationModFile(dir)
   generateMoveDebugTranslationModFile(dir)
   generateItemsDebugTranslationFile(dir)
   generateMonsDebugTranslationFile(dir)
   generateNaturesDebugTranslationFile(dir)
   generateMapInfoDebugTranslationFile(lang, dir)
   generateTrainersDebugTranslationFile(dir)
   generateFieldsDebugTranslationFile(dir)
end

#just use for start fr translation
def gotText(text)
    if text && !text.empty?
        message = File.open(DIR_DEBUG_I18N + "fr/" + MESSAGE_FILE + ".txt")
        stop = false
        message.each_line { |line| 
            line = line.strip
            if stop
                return line
            elsif line == text
                stop = true
            end
        }
    end
    return ""
end

def normalizeData(text) 
    if text.to_i.to_s == text
        return "[]" + text
    end
    return text
end


def generateAbilityDebugTranslationModFile(dir)
    file = File.new(dir + "/" + ABILITIES_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/abiltext.rb") { |f|
        eval(f.read)
    }
    names = "[1]\n"
    descriptions = "[2]\n"
    begin
        ABILHASH.each { |key, value|
            if value[:ID]
                names += value[:ID].to_s + "\n" + normalizeData(value[:name]) + "\n" + normalizeData(value[:name]) + "\n"
                descriptions += value[:ID].to_s + "\n" + normalizeData(value[:desc]) + "\n" + normalizeData(value[:desc]) + "\n"
            end
        }
    rescue => e
        Kernel.pbMessage(pbGetExceptionMessage(e))
    end
    file.puts(names)
    file.flush
    file.puts(descriptions)
    file.flush
    file.close
end

def generateMoveDebugTranslationModFile(dir)
    file = File.new(dir + "/" + MOVES_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/movetext.rb") { |f|
        eval(f.read)
    }
    names = "[1]\n"
    descriptions = "[2]\n"
    begin
        MOVEHASH.each { |key, value|
            if value[:ID]
                names += value[:ID].to_s + "\n" + normalizeData(value[:name]) + "\n" + normalizeData(value[:name]) + "\n"
                descriptions += value[:ID].to_s + "\n" + normalizeData(value[:desc]) + "\n" + normalizeData(value[:desc]) + "\n"
            end
        }
    rescue => e
        Kernel.pbMessage(pbGetExceptionMessage(e))
    end
    file.puts(names)
    file.flush
    file.puts(descriptions)
    file.flush
    file.close
end

def generateMessageDebugTranslationFile(dir)
    origMessages = Messages.new("Data/" + MESSAGE_FILE + ".dat")
    begin
        File.open(dir + "/" + MESSAGE_FILE + ".txt", "wb") { |f|
        f.write("# To localize this text for a particular language, please\r\n")
        f.write("# translate every second line of this file.\r\n")
        if origMessages.messages[0]
            for i in 0...origMessages.messages[0].length
            msgs = origMessages.messages[0][i]
            Messages.writeObject(f, msgs, "Map#{i}", origMessages)
            end
        end
        for i in 1...origMessages.messages.length
            msgs = origMessages.messages[i]
            Messages.writeObject(f, msgs, i, origMessages)
        end
        }
    rescue => e
        Kernel.pbMessage(pbGetExceptionMessage(e))
    end
  end

  
def generateItemsDebugTranslationFile(dir)
    file = File.new(dir + "/" + ITEM_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/itemtext.rb") { |f|
      eval(f.read)
    }
    names = "[1]\n"
    descriptions = "[2]\n"
    begin
        ITEMHASH.each { |key, value|
            if value[:ID]
                names += value[:ID].to_s + "\n" + normalizeData(value[:name]) + "\n" + normalizeData(value[:name]) + "\n"
                descriptions += value[:ID].to_s + "\n" + normalizeData(value[:desc]) + "\n" + normalizeData(value[:desc]) + "\n"
            end
        }
    rescue => e
        Kernel.pbMessage(pbGetExceptionMessage(e))
    end
    file.puts(names)
    file.flush
    file.puts(descriptions)
    file.flush
    file.close
  end

  def generateMonsDebugTranslationFile(dir)
    file = File.new(dir + "/" + MONS_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/montext.rb") { |f|
      eval(f.read)
    }
    names = "[1]\n"
    descriptions = "[2]\n"
    kind = "[3]\n"
    defi = nil
    begin
        MONHASH.each { |key, value|
            value.each do |name, definition|
                if definition.instance_of? Hash
                    defi = definition
                    if definition[:dexnum]
                        names += definition[:dexnum].to_s + "\n" + normalizeData(definition[:name]) + "\n" + normalizeData(definition[:name]) + "\n"
                        descriptions += definition[:dexnum].to_s + "\n" + normalizeData(definition[:dexentry]) + "\n" + normalizeData(definition[:dexentry]) + "\n"
                        kind += definition[:dexnum].to_s + "\n" + normalizeData(definition[:kind]) + "\n" + normalizeData(definition[:kind]) + "\n"
                    elsif definition[:name] && definition[:dexentry] && definition[:kind]
                        names += normalizeData(definition[:name]) + "\n" + normalizeData(definition[:name]) + "\n"
                        descriptions += normalizeData(definition[:dexentry]) + "\n" + normalizeData(definition[:dexentry]) + "\n"
                        kind += normalizeData(definition[:kind]) + "\n" + normalizeData(definition[:kind]) + "\n"
                    elsif definition[:name] && definition[:dexentry]
                        names += normalizeData(definition[:name]) + "\n" + normalizeData(definition[:name]) + "\n"
                        descriptions += normalizeData(definition[:dexentry]) + "\n" + normalizeData(definition[:dexentry]) + "\n"
                    elsif definition[:name] && definition[:kind]
                        names += normalizeData(definition[:name]) + "\n" + normalizeData(definition[:name]) + "\n"
                        kind += normalizeData(definition[:kind]) + "\n" + normalizeData(definition[:kind]) + "\n"
                    elsif definition[:kind] && definition[:dexentry]
                        kind += normalizeData(definition[:kind]) + "\n" + normalizeData(definition[:kind]) + "\n"
                        descriptions += normalizeData(definition[:dexentry]) + "\n" + normalizeData(definition[:dexentry]) + "\n"
                    elsif definition[:name]
                        names += normalizeData(definition[:name]) + "\n" + normalizeData(definition[:name]) + "\n"
                    elsif definition[:dexentry]
                        descriptions += normalizeData(definition[:dexentry]) + "\n" + normalizeData(definition[:dexentry]) + "\n"
                    elsif definition[:kind]
                        kind += normalizeData(definition[:kind]) + "\n" + normalizeData(definition[:kind]) + "\n"
                    end
                end
            end
        }
      rescue => e
        Kernel.pbMessage(pbGetExceptionMessage(e))
      end
    file.puts(names)
    file.flush
    file.puts(descriptions)
    file.flush
    file.puts(kind)
    file.flush
    file.close
  end

  def generateNaturesDebugTranslationFile(dir)
    file = File.new(dir + "/" + NATURE_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/naturetext.rb") { |f|
      eval(f.read)
    }
    names = "[1]\n"
    i = 0
    NATUREHASH.each { |key, value|
        names += i.to_s + "\n" + normalizeData(value[:name]) + "\n" + normalizeData(value[:name]) + "\n"
        i += 1
    }
    file.puts(names)
    file.flush
    file.close
  end

  def generateMapInfoDebugTranslationFile(lang, dir)
    actualLang = $Settings.language
    tempLang = LANGUAGES.map{|i| i[1]}.find_index(lang)

    $Settings.language = tempLang
    $cache.cacheMapInfosReload
    file = File.new(dir + "/" + MAP_INFO_FILE + ".txt", "w")
    names = "[1]\n"
    i = 0
    $cache.mapinfos.each { |key, value|
        if value.name
            names += key.to_s + "\n" + normalizeData(value.name) + "\n" + normalizeData(value.name) + "\n"
        end
        i += 1
    }

    $Settings.language = actualLang
    $cache.cacheMapInfosReload
    file.puts(names)
    file.flush
    file.close
  end

#just use for start fr translation
def generateTrainersDebugConvertTranslationFile
    file = File.new(DIR_DEBUG_I18N + "en" + "/" + TRAINER_FILE + "2.txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/trainertext.rb") { |f|
      eval(f.read)
    }
    i = 1
    names = "[1]\n"
    for trainer in TEAMARRAY
      next if trainer.nil?
      name = trainer[:teamid][0]
      pkmn = trainer[:mons]
      defeat = trainer[:defeat] ? Messages.normalizeValue(trainer[:defeat]) : ""
      defeat2 = trainer[:defeat] ? gotText(Messages.normalizeValue(trainer[:defeat])) : ""

      names += i.to_s + "\n" + normalizeData(name) + "\n" + normalizeData(name) + "\n"
      names += normalizeData(defeat) + "\n" + normalizeData(defeat2) + "\n"
      pkmn.each { |value|
        pokeSpecies = value[:species].to_s
        pokeName = value[:name] ? value[:name] : ""
        pokeGender = value[:gender] ? value[:gender] : ""
        pokeItem = value[:item] ? value[:item].to_s : ""
        pokeNature = value[:nature] ? value[:nature].to_s : ""
        pokeAbility = value[:ability] ? value[:ability].to_s : ""
        pokeMoves = value[:moves] ? value[:moves].join("|") : ""
        pokeEv = value[:ev] ? value[:ev].join("|") : "0|0|0|0|0|0"
        pokeLevel = value[:level] ? value[:level].to_s : "1"
        names += pokeSpecies + "," + pokeLevel + "," + pokeItem + "," + pokeMoves + "," + pokeGender + "," + pokeAbility + "," + pokeNature + "," + pokeName + "," + pokeEv + "\n"
        names += pokeSpecies + "," + pokeLevel + "," + pokeItem + "," + pokeMoves + "," + pokeGender + "," + pokeAbility + "," + pokeNature + "," + pokeName + "," + pokeEv + "\n"
      }
      i += 1
    end
    file.puts(names)
    file.flush
    file.close
  end

def generateTrainersDebugTranslationFile(dir)
    file = File.new(dir + "/" + TRAINER_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/trainertext.rb") { |f|
      eval(f.read)
    }
    i = 1
    names = "[1]\n"
    for trainer in TEAMARRAY
      next if trainer.nil?
      name = trainer[:teamid][0]
      pkmn = trainer[:mons]
      defeat = trainer[:defeat] ? Messages.normalizeValue(trainer[:defeat]) : ""

      names += i.to_s + "\n" + normalizeData(name) + "\n" + normalizeData(name) + "\n"
      names += normalizeData(defeat) + "\n" + normalizeData(defeat) + "\n"
      pkmn.each { |value|
        pokeSpecies = value[:species].to_s
        pokeName = value[:name] ? value[:name] : ""
        pokeGender = value[:gender] ? value[:gender] : ""
        pokeItem = value[:item] ? value[:item].to_s : ""
        pokeNature = value[:nature] ? value[:nature].to_s : ""
        pokeAbility = value[:ability] ? value[:ability].to_s : ""
        pokeMoves = value[:moves] ? value[:moves].join("|") : ""
        pokeEv = value[:ev] ? value[:ev].join("|") : "0|0|0|0|0|0"
        pokeLevel = value[:level] ? value[:level].to_s : "1"
        names += pokeSpecies + "," + pokeLevel + "," + pokeItem + "," + pokeMoves + "," + pokeGender + "," + pokeAbility + "," + pokeNature + "," + pokeName + "," + pokeEv + "\n"
        names += pokeSpecies + "," + pokeLevel + "," + pokeItem + "," + pokeMoves + "," + pokeGender + "," + pokeAbility + "," + pokeNature + "," + pokeName + "," + pokeEv + "\n"
      }
      i += 1
    end
    file.puts(names)
    file.flush
    file.close
  end

  def generateFieldsDebugTranslationFile(dir)
    file = File.new(dir + "/" + FIELD_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/fieldtext.rb") { |f| eval(f.read) }
    
    i = 1
    names = "[1]\n"
    description = "[2]\n"
  
    FIELDEFFECTS.each { |key, data|
        names += i.to_s + "\n" + key.to_s + "\n" + key.to_s + "\n" + data[:name] + "\n" + data[:name] + "\n"
        description += i.to_s + "\n"
        description += data[:fieldMessage].join("|") + "\n" + data[:fieldMessage].join("|") + "\n"
        description += data[:moveMessages].keys.join("|") + "\n" + data[:moveMessages].keys.join("|") + "\n"
        description += data[:typeMessages].keys.join("|") + "\n" + data[:typeMessages].keys.join("|") + "\n"
        description += data[:changeMessage].keys.join("|") + "\n" + data[:changeMessage].keys.join("|") + "\n"
        description += data[:seed] && data[:seed][:message] ? data[:seed][:message] + "\n" + data[:seed][:message] + "\n" : "\n\n"
        i += 1
    }
    file.puts(names)
    file.flush
    file.puts(description)
    file.flush
    file.close
  end

  

  def generateFieldsDebugConvertTranslationFile(dir)
    file = File.new(dir + "/" + FIELD_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/fieldtext.rb") { |f| eval(f.read) }
    
    i = 1
    names = "[1]\n"
    description = "[2]\n"
  
    FIELDEFFECTS.each { |key, data|
        names += i.to_s + "\n" + key.to_s + "\n" + key.to_s + "\n" + data[:name] + "\n" + gotText(data[:name]) + "\n"
        description += i.to_s + "\n"
        description += data[:fieldMessage].join("|") + "\n" + data[:fieldMessage].map{|e| gotText(e)}.join("|") + "\n"
        description += data[:moveMessages].keys.join("|") + "\n" + data[:moveMessages].keys.map{|e| gotText(e)}.join("|") + "\n"
        description += data[:typeMessages].keys.join("|") + "\n" + data[:typeMessages].keys.map{|e| gotText(e)}.join("|") + "\n"
        description += data[:changeMessage].keys.join("|") + "\n" + data[:changeMessage].keys.map{|e| gotText(e)}.join("|") + "\n"
        description += data[:seed] && data[:seed][:message] ? data[:seed][:message] + "\n" + gotText(data[:seed][:message]) + "\n" : "\n\n"
        i += 1
    }
    file.puts(names)
    file.flush
    file.puts(description)
    file.flush
    file.close
  end