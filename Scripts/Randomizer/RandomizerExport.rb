def randomizerPrint(pkmn)
  exporttext = "MONHASH = {\n"
  for i in pkmn.keys
    mon = pkmn[i]
    $stdout.flush
    cprint "Pokemon line #{i}             \r"
    # print mon.inspect
    exporttext += ":#{i} => {\n"
    if mon.forms.empty?
      exporttext += "  \"Normal Form\" => {\n"
      exporttext += getMonOutput(mon)
    else
      for form in 0...mon.forms.length
        formthing = ""
        exporttext += "  \"#{mon.forms[form]}#{formthing}\" => {\n"
        if form == 0
          exporttext += getMonOutput(mon)
          next
        end
        exporttext += "    :name => \"#{mon.formData.dig(mon.forms[form], :name)}\",\n" if mon.formData.dig(mon.forms[form], :name)
        exporttext += "    :dexnum => #{mon.formData.dig(mon.forms[form], :dexnum)},\n" if mon.formData.dig(mon.forms[form], :dexnum)
        exporttext += "    :Type1 => :#{mon.formData.dig(mon.forms[form], :Type1)},\n" if mon.formData.dig(mon.forms[form], :Type1)
        exporttext += "    :Type2 => :#{mon.formData.dig(mon.forms[form], :Type2)},\n" if mon.formData.dig(mon.forms[form], :Type2)
        exporttext += "    :BaseStats => #{mon.formData.dig(mon.forms[form], :BaseStats).inspect},\n" if mon.formData.dig(mon.forms[form], :BaseStats)
        exporttext += "    :EVs => #{mon.formData.dig(mon.forms[form], :EVs).inspect},\n" if mon.formData.dig(mon.forms[form], :EVs)
        exporttext += "    :Abilities => #{mon.formData.dig(mon.forms[form], :Abilities)},\n" if mon.formData.dig(mon.forms[form], :Abilities)
        exporttext += "    :HiddenAbilities => :#{mon.formData.dig(mon.forms[form], :HiddenAbilities)},\n" if mon.formData.dig(mon.forms[form], :HiddenAbilities)
        exporttext += "    :GrowthRate => :#{mon.formData.dig(mon.forms[form], :GrowthRate)},\n" if mon.formData.dig(mon.forms[form], :GrowthRate)
        exporttext += "    :GenderRatio => :#{mon.formData.dig(mon.forms[form], :GenderRatio)},\n" if mon.formData.dig(mon.forms[form], :GenderRatio)
        exporttext += "    :BaseEXP => #{mon.formData.dig(mon.forms[form], :BaseEXP)},\n" if mon.formData.dig(mon.forms[form], :BaseEXP)
        exporttext += "    :CatchRate => #{mon.formData.dig(mon.forms[form], :CatchRate)},\n" if mon.formData.dig(mon.forms[form], :CatchRate)
        exporttext += "    :Happiness => #{mon.formData.dig(mon.forms[form], :Happiness)},\n" if mon.formData.dig(mon.forms[form], :Happiness)
        exporttext += "    :EggSteps => #{mon.formData.dig(mon.forms[form], :EggSteps)},\n" if mon.formData.dig(mon.forms[form], :EggSteps)
        if mon.formData.dig(mon.forms[form], :EggMoves)
          exporttext += "    :EggMoves => ["
          for eggmove in mon.formData.dig(mon.forms[form], :EggMoves)
            exporttext += ":#{eggmove},"
          end
          exporttext += "],\n"
        end
        if mon.formData.dig(mon.forms[form], :preevo)
          exporttext += "    :preevo => {\n"
          exporttext += "      :species => :#{mon.formData.dig(mon.forms[form], :preevo)[:species]},\n"
          exporttext += "      :form => #{mon.formData.dig(mon.forms[form], :preevo)[:form]}\n"
          exporttext += "    },\n"
        end
        if mon.formData.dig(mon.forms[form], :Moveset)
          exporttext += "    :Moveset => [\n"
          for move in mon.formData.dig(mon.forms[form], :Moveset)
            exporttext += "      [#{move[0]},:#{move[1]}]"
            exporttext += ",\n"
          end
          exporttext += "    ],\n"
        end
        if mon.formData.dig(mon.forms[form], :compatiblemoves)
          exporttext += "    :compatiblemoves => ["
          for j in mon.formData.dig(mon.forms[form], :compatiblemoves)
            next if PBStuff::UNIVERSALTMS.include?(j)

            exporttext += ":#{j},"
          end
          exporttext += "],\n"
        end
        if mon.formData.dig(mon.forms[form], :moveexceptions)
          exporttext += "    :moveexceptions => ["
          for j in mon.formData.dig(mon.forms[form], :moveexceptions)
            exporttext += ":#{j},"
          end
          exporttext += "],\n"
        end
        if mon.formData.dig(mon.forms[form], :shadowmoves)
          exporttext += "    :shadowmoves => ["
          for shadowmove in mon.formData.dig(mon.forms[form], :shadowmoves)
            exporttext += ":#{shadowmove},"
          end
          exporttext += "],\n"
        end
        exporttext += "    :Color => \"#{mon.formData.dig(mon.forms[form], :Color)}\",\n" if mon.formData.dig(mon.forms[form], :Color)
        exporttext += "    :Habitat => \"#{mon.formData.dig(mon.forms[form], :Habitat)}\",\n" if mon.formData.dig(mon.forms[form], :Habitat)
        exporttext += "    :EggGroups => #{mon.formData.dig(mon.forms[form], :EggGroups)},\n" if mon.formData.dig(mon.forms[form], :EggGroups)
        exporttext += "    :Height => #{mon.formData.dig(mon.forms[form], :Height)},\n" if mon.formData.dig(mon.forms[form], :Height)
        exporttext += "    :Weight => #{mon.formData.dig(mon.forms[form], :Weight)},\n" if mon.formData.dig(mon.forms[form], :Weight)
        exporttext += "    :WildItemCommon => :#{mon.formData.dig(mon.forms[form], :WildItemCommon)},\n" if mon.formData.dig(mon.forms[form], :WildItemCommon)
        exporttext += "    :WildItemUncommon => :#{mon.formData.dig(mon.forms[form], :WildItemUncommon)},\n" if mon.formData.dig(mon.forms[form], :WildItemUncommon)
        exporttext += "    :WildItemRare => :#{mon.formData.dig(mon.forms[form], :WildItemRare)},\n" if mon.formData.dig(mon.forms[form], :WildItemRare)
        exporttext += "    :kind => \"#{mon.formData.dig(mon.forms[form], :kind)}\",\n" if mon.formData.dig(mon.forms[form], :kind)
        exporttext += "    :dexentry => \"#{mon.formData.dig(mon.forms[form], :dexentry)}\",\n" if mon.formData.dig(mon.forms[form], :dexentry)
        exporttext += "    :BattlerPlayerY => #{mon.formData.dig(mon.forms[form], :BattlerPlayerY)},\n" if mon.formData.dig(mon.forms[form], :BattlerPlayerY)
        exporttext += "    :BattlerEnemyY => #{mon.formData.dig(mon.forms[form], :BattlerEnemyY)},\n" if mon.formData.dig(mon.forms[form], :BattlerEnemyY)
        exporttext += "    :BattlerAltitude => #{mon.formData.dig(mon.forms[form], :BattlerAltitude)},\n" if mon.formData.dig(mon.forms[form], :BattlerAltitude)
        if mon.formData.dig(mon.forms[form], :evolutions)
          evos = mon.formData.dig(mon.forms[form], :evolutions)
          check = 1
          exporttext += "    :evolutions => [\n"
          for evo in evos
            exporttext += "      [:#{evo[0].to_s},:#{evo[1].to_s}"
            evomethods = ["Item", "ItemMale", "ItemFemale", "TradeItem", "DayHoldItem", "NightHoldItem"]
            if evomethods.include?(evo[1].to_s)
              exporttext += ",:#{evo[2].to_s}"
            else
              exporttext += ",#{evo[2].is_a?(Integer) ? "" : ":"}#{evo[2].to_s}" if evo[2]
            end
            exporttext += "],\n" if check != evos.length
            exporttext += "]\n" if check == evos.length
            check += 1
          end
          exporttext += "    ]\n"
        end
        exporttext += "  },\n\n"
      end
      exporttext += "  :OnCreation => #{mon.formInit},\n" if mon.formInit
      exporttext += "  :MegaForm => #{mon.formData.dig(:MegaForm)},\n" if mon.formData.dig(:MegaForm)
      exporttext += "  :PrimalForm => #{mon.formData.dig(:PrimalForm)},\n" if mon.formData.dig(:PrimalForm)
      exporttext += "  :DefaultForm => #{mon.formData.dig(:DefaultForm)},\n" if mon.formData.dig(:DefaultForm)
    end
    exporttext += "},\n\n"

  end
  exporttext += "}"
  cprint "Successfully dumped Pokemon data        \n"
  File.open("Scripts/" + GAMEFOLDER + "/montextconverter.rb", "w") { |f|
    f.write(exporttext)
  }
end
