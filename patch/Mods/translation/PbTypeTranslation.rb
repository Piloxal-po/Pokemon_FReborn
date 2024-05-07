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
        return "Qmark"
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

def pbItemIconFile(item, conversion = false)
    return "Graphics/Icons/itemBack" if !item
  
    bitmapFileName = nil
    tmmove = pbGetTM(item)
    if tmmove
      type = $cache.moves[tmmove].type
      typename = getTypeName(type)
      return getPathWithTranslation(sprintf("Graphics/Icons/TM - %s", typename))
    end
    image = $cache.items[item].checkFlag?(:image)
    return getPathWithTranslation(sprintf("Graphics/Icons/#{image}")) if image
  
    if !conversion
      bitmapFileName = getPathWithTranslation(sprintf("Graphics/Icons/%s.png", item)) rescue nil
      if !pbResolveBitmap(bitmapFileName)
        bitmapFileName = getPathWithTranslation(sprintf("Graphics/Icons/%s.png", item))
      end
    else
      bitmapFileName = getPathWithTranslation(sprintf("Graphics/Icons/%s", $cache.items[item].checkFlag?(:ID))) rescue nil
      if !pbResolveBitmap(bitmapFileName)
        bitmapFileName = getPathWithTranslation(sprintf("Graphics/Icons/%03d", $cache.items[item].checkFlag?(:ID)))
      end
    end
    return bitmapFileName
  end