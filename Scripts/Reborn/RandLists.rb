def pbGetMegaStoneList
  m = pbHashForwardizer(PBStuff::POKEMONTOMEGASTONE)
  return m.keys
end

def pbGetMegaList
  m = PBStuff::POKEMONTOMEGASTONE.keys
  return m
end

def pbGetSpecialZType
  z={PBSpecies::RAICHU=>{PBMoves::THUNDERBOLT=>PBItems::ALOLARAICHIUMZ2},
  PBSpecies::DECIDUEYE=>{PBMoves::SPIRITSHACKLE=>PBItems::DECIDIUMZ2},
  PBSpecies::INCINEROAR=>{PBMoves::DARKESTLARIAT=>PBItems::INCINIUMZ2},
  PBSpecies::PRIMARINA=>{PBMoves::SPARKLINGARIA=>PBItems::PRIMARIUMZ2},
  PBSpecies::EEVEE=>{PBMoves::LASTRESORT=>PBItems::EEVIUMZ2},
  PBSpecies::PIKACHU=>{PBMoves::VOLTTACKLE=>PBItems::PIKANIUMZ2},
  PBSpecies::SNORLAX=>{PBMoves::BODYSLAM=>PBItems::SNORLIUMZ2},
  PBSpecies::MEW=>{PBMoves::PSYCHIC=>PBItems::MEWNIUMZ2},
  PBSpecies::TAPUBULU||PBSpecies::TAPUFINI||PBSpecies::TAPUKOKO||
  PBSpecies::TAPULELE=>{PBMoves::NATURESMADNESS=>PBItems::TAPUNIUMZ2},
  PBSpecies::MARHSADOW=>{PBMoves::SPECTRALTHIEF=>PBItems::MARSHADIUMZ2},
  PBSpecies::KOMMOO=>{PBMoves::CLANGINGSCALES=>PBItems::KOMMONIUMZ2},
  PBSpecies::LYCANORC=>{PBMoves::STONEEDGE=>PBItems::LYCANIUMZ2},
  PBSpecies::MIMIKYU=>{PBMoves::PLAYROUGH=>PBItems::MIMIKIUMZ2},
  PBSpecies::SOLGALEO=>{PBMoves::STUNSTEELSTRIKE=>PBItems::SOLGALIUMZ2},
  PBSpecies::LUNALA=>{PBMoves::MOONGEISTBEAM=>PBItems::LUNALIUMZ2},
  PBSpecies::NECROZMA=>{PBMoves::PHOTONGEYSER=>PBItems::ULTRANECROZIUMZ2}}
  return z
end

def pbGetZCrysType
  c={PBTypes::BUG=>PBItems::BUGINIUMZ2,PBTypes::DARK=>PBItems::DARKINIUMZ2,
  PBTypes::DRAGON=>PBItems::DRAGONIUMZ2,PBTypes::ELECTRIC=>PBItems::ELECTRIUMZ2,
  PBTypes::FAIRY=>PBItems::FAIRIUMZ2,PBTypes::FIGHTING=>PBItems::FIGHTINIUMZ2,
  PBTypes::FIRE=>PBItems::FIRIUMZ2,PBTypes::FLYING=>PBItems::FLYINIUMZ2,
  PBTypes::GHOST=>PBItems::GHOSTIUMZ2,PBTypes::GRASS=>PBItems::GRASSIUMZ2,
  PBTypes::GROUND=>PBItems::GROUNDIUMZ2,PBTypes::ICE=>PBItems::ICIUMZ2,
  PBTypes::NORMAL=>PBItems::NORMALIUMZ2,PBTypes::POISON=>PBItems::POISONIUMZ2,
  PBTypes::PSYCHIC=>PBItems::PSYCHIUMZ2,PBTypes::ROCK=>PBItems::ROCKIUMZ2,
  PBTypes::STEEL=>PBItems::STEELIUMZ2,PBTypes::WATER=>PBItems::WATERIUMZ2}
  return c
end


def pbGetCrystal
  c=[PBItems::BUGINIUMZ2,PBItems::DARKINIUMZ2,PBItems::DRAGONIUMZ2,
  PBItems::ELECTRIUMZ2,PBItems::FAIRIUMZ2,PBItems::FIGHTINIUMZ2,PBItems::FIRIUMZ2,
  PBItems::FLYINIUMZ2,PBItems::GHOSTIUMZ2,PBItems::GRASSIUMZ2,
  PBItems::GROUNDIUMZ2,PBItems::ICIUMZ2,PBItems::NORMALIUMZ2,PBItems::POISONIUMZ2,
  PBItems::PSYCHIUMZ2,PBItems::ROCKIUMZ2,PBItems::STEELIUMZ2,PBItems::WATERIUMZ2]
  return c
end

def pbRandBlacklist
  r=[PBSpecies::ARCEUS]
  return r
end