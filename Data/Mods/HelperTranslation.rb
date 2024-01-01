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
        for i in 0...HISTORY.length
            Kernel.pbMessage(i.to_s() + " : " + HISTORY[i].to_s())
        end
      end
    end
  end