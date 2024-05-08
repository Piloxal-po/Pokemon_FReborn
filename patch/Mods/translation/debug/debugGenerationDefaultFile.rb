def generateDebugTranslationModFile
    lang = choiceLanguage
    dir = DIR_DEBUG_I18N + lang
    debugMkdir(dir)
    t2 = Thread.new{generateAbilityDebugTranslationModFile(dir)}
    t3 = Thread.new{generateMoveDebugTranslationModFile(dir)}
    t4 = Thread.new{generateMessageDebugTranslationFile(dir)}
    t5 = Thread.new{generateItemsDebugTranslationFile(dir)}
    t6 = Thread.new{generateMonsDebugTranslationFile(dir)}
    t7 = Thread.new{generateNaturesDebugTranslationFile(dir)}
    t8 = Thread.new{generateMapInfoDebugTranslationFile(dir)}
    t2.join()
    t3.join()
    t4.join()
    t5.join()
    t6.join()
    t7.join()
    t8.join()
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
                names += value[:ID].to_s + "\n" + value[:name] + "\n" + value[:name] + "\n"
                descriptions += value[:ID].to_s + "\n" + value[:desc] + "\n" + value[:desc] + "\n"
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
                names += value[:ID].to_s + "\n" + value[:name] + "\n" + value[:name] + "\n"
                descriptions += value[:ID].to_s + "\n" + value[:desc] + "\n" + value[:desc] + "\n"
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
                names += value[:ID].to_s + "\n" + value[:name] + "\n" + value[:name] + "\n"
                descriptions += value[:ID].to_s + "\n" + value[:desc] + "\n" + value[:desc] + "\n"
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
                        names += definition[:dexnum].to_s + "\n" + definition[:name] + "\n" + definition[:name] + "\n"
                        descriptions += definition[:dexnum].to_s + "\n" + definition[:dexentry] + "\n" + definition[:dexentry] + "\n"
                        kind += definition[:dexnum].to_s + "\n" + definition[:kind] + "\n" + definition[:kind] + "\n"
                    elsif definition[:name] && definition[:dexentry] && definition[:kind]
                        names += definition[:name] + "\n" + definition[:name] + "\n"
                        descriptions += definition[:dexentry] + "\n" + definition[:dexentry] + "\n"
                        kind += definition[:kind] + "\n" + definition[:kind] + "\n"
                    elsif definition[:name] && definition[:dexentry]
                        names += definition[:name] + "\n" + definition[:name] + "\n"
                        descriptions += definition[:dexentry] + "\n" + definition[:dexentry] + "\n"
                    elsif definition[:name] && definition[:kind]
                        names += definition[:name] + "\n" + definition[:name] + "\n"
                        kind += definition[:kind] + "\n" + definition[:kind] + "\n"
                    elsif definition[:kind] && definition[:dexentry]
                        kind += definition[:kind] + "\n" + definition[:kind] + "\n"
                        descriptions += definition[:dexentry] + "\n" + definition[:dexentry] + "\n"
                    elsif definition[:name]
                        names += definition[:name] + "\n" + definition[:name] + "\n"
                    elsif definition[:dexentry]
                        descriptions += definition[:dexentry] + "\n" + definition[:dexentry] + "\n"
                    elsif definition[:kind]
                        kind += definition[:kind] + "\n" + definition[:kind] + "\n"
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
        names += i.to_s + "\n" + value[:name] + "\n" + value[:name] + "\n"
        i += 1
    }
    file.puts(names)
    file.flush
    file.close
  end

  def generateMapInfoDebugTranslationFile(dir)
    file = File.new(dir + "/" + MAP_INFO_FILE + ".txt", "w")
    names = "[1]\n"
    i = 0
    $cache.mapinfos.each { |key, value|
        if value.name
            names += key.to_s + "\n" + value.name + "\n" + value.name + "\n"
        end
        i += 1
    }
    file.puts(names)
    file.flush
    file.close
  end