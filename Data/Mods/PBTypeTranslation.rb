def getTypeRootName(id)
    case id
    when PBTypes::NORMAL
        return "Normal"
    when PBTypes::FIGHTING
        return "Fighting"
    when PBTypes::FLYING
        return "Flying"
    when PBTypes::POISON
        return "Poison"
    when PBTypes::GROUND
        return "Ground"
    when PBTypes::ROCK
        return "Rock"
    when PBTypes::BUG
        return "Bug"
    when PBTypes::GHOST
        return "Ghost"
    when PBTypes::STEEL
        return "Steel"
    when PBTypes::QMARKS
        return "???"
    when PBTypes::FIRE
        return "Fire"
    when PBTypes::WATER
        return "Water"
    when PBTypes::GRASS
        return "Grass"
    when PBTypes::ELECTRIC
        return "Electric"
    when PBTypes::PSYCHIC
        return "Psychic"
    when PBTypes::ICE
        return "Ice"
    when PBTypes::DARK
        return "Dark"
    when PBTypes::FAIRY
        return "Fairy"
    when PBTypes::DRAGON
        return "Dragon"
    else
        return nil
    end
end

def pbGetTypeNameFile(id)
    return getTypeRootName(id) + getSuffixFile();
end

def pbItemIconFile(item)
    return nil if !item
    bitmapFileName=nil
    if item==0
      bitmapFileName=sprintf("Graphics/Icons/itemBack")
    else
      moveid = $cache.items[item][ITEMMACHINE]
      if moveid != 0 #This is 0 if it's not a TM.
        type = $cache.pkmn_move[moveid][2]
        typename = getTypeRootName(type)
        bitmapFileName=sprintf("Graphics/Icons/TM - %s",typename)
      else
        bitmapFileName=sprintf("Graphics/Icons/item%s",getConstantName(PBItems,item)) rescue nil
        if !pbResolveBitmap(bitmapFileName)
          bitmapFileName=sprintf("Graphics/Icons/item%03d",item)
        end
      end
    end
    return bitmapFileName
  end

def getSuffixFile()
    if (LANGUAGES.length>=2 && LANGUAGES[$idk[:settings].language][1] != "en")
        return "_" + LANGUAGES[$idk[:settings].language][1]
    else
        return ""
    end
end