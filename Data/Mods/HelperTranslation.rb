HISTORY = []
MAX_HISTORY = 20

def _MAPINTL(mapid,*arg)
    base = arg[0]
    translate=MessageTypes.getFromMapHash(mapid,arg[0])
    transform=translate.clone
    for i in 1...arg.length
        transform.gsub!(/\{#{i}\}/,"#{arg[i]}")
    end
    pushInHistory(base, transform)
    return transform
  end

def pushInHistory(base, transform)
    if (!HISTORY.include? [base, transform])
        if (HISTORY.length() >= MAX_HISTORY)
            HISTORY.shift 
        end
        HISTORY.push([base, transform])
    end
end

def appendErrorTranslationFile(type, key)
    type = 0 if !type
    text = type.to_s() + " : " + key.to_s()
    errorTranslationFile = File.open("errorTranslation.txt", "a+")
    if (!errorTranslationFile.each_line.any?{|line| line.include?(text)})
        errorTranslationFile.write(type.to_s() + " : " + key.to_s() + "\n")
    end
    errorTranslationFile.close()
end

class Messages
    def getFromMapHash(type,key)
        delayedLoad
        if (!@messages || !@messages[0] || !@messages[0][0])
            appendErrorTranslationFile("ERROR LOAD FILE", key)
            return key
        end
        id=Messages.stringToKey(key)
        if @messages[0][type] &&  @messages[0][type][id]
          return @messages[0][type][id]
        elsif @messages[0][0] && @messages[0][0][id]
          return @messages[0][0][id]
        end
        appendErrorTranslationFile(type, key)
        return key
      end
end

module Input
    unless defined?(update_KGC_ScreenCapture)
      class << Input
        alias update_KGC_ScreenCapture update
      end
    end
  
    def self.update
      update_KGC_ScreenCapture
      if trigger?(:F8)
        pbScreenCapture
      end
      if triggerex?(:LALT) || (triggerex?(:M) && Input.text_input != true) || triggerex?(:RALT) || (Input.trigger?(Input::Y) && Input.trigger?(Input::X))
        pbTurbo()
      end
      if triggerex?(:F7)
        if $game_system
          $game_system.toggle_mute
        end
      end
      if triggerex?(:F10) && $DEBUG
        if $is_profile != true
          $is_profile = true
          Kernel.pbMessage("Begin profiling")
          CP_Profiler.begin
        end
      end
      if triggerex?(:F11) && $DEBUG
        CP_Profiler.print
        $is_profile = false
      end
      if triggerex?(:F6) && $DEBUG
        begin
          Input.text_input = true
          code = Kernel.pbMessageFreeText(_INTL("What code would you like to run?"),"",false,999,500)
          eval(code)
          Input.text_input = false
        rescue
          pbPrintException($!)
          Input.text_input = false
        end
      end
      if triggerex?(:F3)
        reverse = HISTORY.reverse()
        for i in 0...reverse.length
            Kernel.pbMessage(i.to_s() + " : " + reverse[i].to_s())
        end
      end
    end
  end