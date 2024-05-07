def generateDebugTranslationModFile
    lang = choiceLanguage
    dir = DIR_DEBUG_I18N + lang
    debugMkdir(dir)
    generateAbilityDebugTranslationModFile(dir)
    generateMoveDebugTranslationModFile(dir)
    generateMessageDebugTranslationFile(dir)
    generateItemsDebugTranslationFile(dir)
end

def generateAbilityDebugTranslationModFile(dir)
    file = File.new(dir + "/" + ABILITIES_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/abiltext.rb") { |f|
        eval(f.read)
    }
    names = "[1]\n"
    descriptions = "[2]\n"
    ABILHASH.each { |key, value|
        if value[:ID]
            names += value[:ID].to_s + "\n" + value[:name] + "\n" + value[:name] + "\n"
            descriptions += value[:ID].to_s + "\n" + value[:desc] + "\n" + value[:desc] + "\n"
        end
    }
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
    MOVEHASH.each { |key, value|
        if value[:ID]
            names += value[:ID].to_s + "\n" + value[:name] + "\n" + value[:name] + "\n"
            descriptions += value[:ID].to_s + "\n" + value[:desc] + "\n" + value[:desc] + "\n"
        end
    }
    file.puts(names)
    file.flush
    file.puts(descriptions)
    file.flush
    file.close
end

def generateMessageDebugTranslationFile(dir)
    origMessages = Messages.new("Data/" + MESSAGE_FILE + ".dat")
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
  end

  
def generateItemsDebugTranslationFile(dir)
    file = File.new(dir + "/" + ITEM_FILE + ".txt", "w")
    File.open("Scripts/" + GAMEFOLDER + "/itemtext.rb") { |f|
      eval(f.read)
    }
    names = "[1]\n"
    descriptions = "[2]\n"
    ITEMHASH.each { |key, value|
        if value[:ID]
            names += value[:ID].to_s + "\n" + value[:name] + "\n" + value[:name] + "\n"
            descriptions += value[:ID].to_s + "\n" + value[:desc] + "\n" + value[:desc] + "\n"
        end
    }
    file.puts(names)
    file.flush
    file.puts(descriptions)
    file.flush
    file.close
  end