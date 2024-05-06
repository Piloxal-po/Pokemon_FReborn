HISTORY_MAPINTL = []

HISTORY_INTL = []
MAX_HISTORY = 20

def _INTL(*arg)
    base = arg[0]
    begin
        translate=MessageTypes.getFromHash(MessageTypes::ScriptTexts,base)
    rescue
        translate=arg[0]
    end
    transform=translate.clone
    transform=transform.dup if transform.frozen?
    for i in 1...arg.length
        transform.gsub!(/\{#{i}\}/,"#{arg[i]}")
    end
    pushInHistory(HISTORY_INTL, base, transform)
    return transform
  end

def _MAPINTL(mapid,*arg)
    base = arg[0]
    translate=MessageTypes.getFromMapHash(mapid,arg[0])
    transform=translate.clone
    for i in 1...arg.length
        transform.gsub!(/\{#{i}\}/,"#{arg[i]}")
    end
    pushInHistory(HISTORY_MAPINTL, base, transform)
    return transform
end

def pushInHistory(array, base, transform)
    if (!array.include? [base, transform])
        if (array.length() >= MAX_HISTORY)
            array.shift 
        end
        array.push([base, transform])
    end
end

def appendErrorTranslationFile(file, type, key)
    type = 0 if !type
    text = type.to_s() + " : " + key.to_s()
    errorTranslationFile = File.open(file, "a+")
    if (!errorTranslationFile.each_line.any?{|line| line.include?(text)})
        errorTranslationFile.write(type.to_s() + " : " + key.to_s() + "\n")
    end
    errorTranslationFile.close()
end

class Messages
    def getFromMapHash(type,key)
        delayedLoad
        if (!@messages || !@messages[0] || !@messages[0][0])
            #appendErrorTranslationFile("errorTranslation.txt", "ERROR LOAD FILE", key)
            return key
        end
        id=Messages.stringToKey(key)
        if @messages[0][type] &&  @messages[0][type][id]
          return @messages[0][type][id]
        elsif @messages[0][0] && @messages[0][0][id]
          return @messages[0][0][id]
        end
        #appendErrorTranslationFile("errorTranslation.txt", type, key)
        return key
      end
end