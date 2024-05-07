class Cache_Game
    def reload()
      cacheDexReload
      cacheMovesReload
      cacheItemsReload
      cacheTrainersReload
      cacheAbilitiesReload
      cacheMessageReload
      cacheFieldsReload
      cacheFieldNotesReload
      cacheTypesReload
      cacheNaturesReload
    end
    
    def cacheDexReload
      if fileExists?(getDiri18n + "mons.dat")
        @pkmn = load_data(getDiri18n + "mons.dat")
      end
    end

    def cacheMovesReload
      if fileExists?(getDiri18n + "moves.dat")
        @moves = load_data(getDiri18n + "moves.dat")
      end
    end

    def cacheItemsReload
      if fileExists?(getDiri18n + "items.dat")
        @items = load_data(getDiri18n + "items.dat")
      end
    end

    def cacheTrainersReload
      if fileExists?(getDiri18n + "trainers.dat")
        @trainers = load_data(getDiri18n + "trainers.dat")
      end
    end

    def cacheAbilitiesReload
      if fileExists?(getDiri18n + "abil.dat")
        @abil = load_data(getDiri18n + "abil.dat")
      end
    end

    def cacheMessageReload
      if fileExists?(getDiri18n + "messages.dat")
        pbLoadMessages(getDiri18n + "messages.dat")
      end
    end

    def cacheFieldsReload
      if fileExists?(getDiri18n + "fields.dat")
        @FEData = load_data(getDiri18n + "fields.dat")
      end
    end

    def cacheFieldNotesReload
      if fileExists?(getDiri18n + "fieldnotes.dat")
        @FENotes = load_data(getDiri18n + "fieldnotes.dat")
      end
    end

    def cacheTypesReload
      if fileExists?(getDiri18n + "types.dat")
        @types = load_data(getDiri18n + "types.dat")
      end
    end

    def cacheNaturesReload
      if fileExists?(getDiri18n + "natures.dat")
        @natures = load_data(getDiri18n + "natures.dat")
      end
    end
  end