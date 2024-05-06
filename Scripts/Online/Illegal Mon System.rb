################################################################################
# Form Check                                                                                                                                                              By Marcello & Kurotsune
################################################################################
def isLegalForm?(pkmn)
  return true unless Reborn # TODO: Handle Rejuv/Deso
  return false if $cache.pkmn[pkmn.species, pkmn.form].flags[:ExcludeDex]
  return false if (pkmn.isMega? || pkmn.isPrimal? || pkmn.isUltra?)
  return false if pkmn.species == :CASTFORM && pkmn.form != 0
  return false if pkmn.species == :CHERRIM && pkmn.form == 1
  return false if pkmn.species == :GIRATINA && pkmn.form == 1 && pkmn.item != :GRISEOUSORB

  if [:ARCEUS, :SILVALLY].include?(pkmn.species)
    return false if pkmn.species == :ARCEUS && pkmn.form == 9

    type_items = [
      [:FISTPLATE, :FIGHTINIUMZ, :FIGHTINGMEMORY], [:SKYPLATE, :FLYINIUMZ, :FLYINGMEMORY], [:TOXICPLATE, :POISONIUMZ, :POISONMEMORY],
      [:EARTHPLATE, :GROUNDIUMZ, :GROUNDMEMORY], [:STONEPLATE, :ROCKIUMZ, :ROCKMEMORY], [:INSECTPLATE, :BUGINIUMZ, :BUGMEMORY],
      [:SPOOKYPLATE, :GHOSTIUMZ, :GHOSTMEMORY], [:IRONPLATE, :STEELIUMZ, :STEELMEMORY], [nil, nil, :GLITCHMEMORY],
      [:FLAMEPLATE, :FIRIUMZ, :FIREMEMORY], [:SPLASHPLATE, :WATERIUMZ, :WATERMEMORY], [:MEADOWPLATE, :GRASSIUMZ, :GRASSMEMORY],
      [:ZAPPLATE, :ELECTRIUMZ, :ELECTRICMEMORY], [:MINDPLATE, :PSYCHIUMZ, :PSYCHICMEMORY], [:ICICLEPLATE, :ICIUMZ, :ICEMEMORY],
      [:DRACOPLATE, :DRAGONIUMZ, :DRAGONMEMORY], [:DREADPLATE, :DARKINIUMZ, :DARKMEMORY], [:PIXIEPLATE, :FAIRIUMZ, :FAIRYMEMORY]
    ]
    type_items.each_with_index { |type, i|
      return false if pkmn.species == :ARCEUS && pkmn.form == i + 1 && !type_items[i][0..1].include?(pkmn.item)
      return false if pkmn.species == :SILVALLY && pkmn.form == i + 1 && pkmn.item != type_items[i][2]
    }
  end
  return false if pkmn.species == :DARMANITAN && pkmn.form == 1

  if pkmn.species == :GENESECT
    drives = [:SHOCKDRIVE, :BURNDRIVE, :CHILLDRIVE, :DOUSEDRIVE]
    drives.each_with_index { |drive, i|
      return false if pkmn.form == i + 1 && pkmn.item != drives[i]
    }
  end
  return false if pkmn.species == :AEGISLASH && pkmn.form != 0
  return false if pkmn.species == :WISHIWASHI && pkmn.form == 1
  return false if pkmn.species == :MINIOR && pkmn.form == 7
  return false if pkmn.species == :MIMIKYU && pkmn.form == 1
  return false if pkmn.species == :CRAMORANT && pkmn.form != 0
  return false if pkmn.species == :EISCUE && pkmn.form != 0
  return false if pkmn.species == :MORPEKO && pkmn.form != 0
  return false if pkmn.species == :ZACIAN && pkmn.form == 1 && pkmn.item != :RUSTEDSWORD
  return false if pkmn.species == :ZAMAZENTA && pkmn.form == 1 && pkmn.item != :RUSTEDSHIELD
  return false if pkmn.species == :ETERNATUS && pkmn.form == 1

  return true
end

################################################################################
# Move Check                                                                                                                                                              This is by Marcello & Kurotsune too
################################################################################
def preEvoLearnsetCheck(move, pkmn)
  pre_evo = pbGetPreviousForm(pkmn.species, pkmn.form)
  if pre_evo == [pkmn.species, pkmn.form]
    return false
  else
    pre_evo = PokeBattle_Pokemon.new(pre_evo[0], 1, $Trainer, false, pre_evo[1])
    return false if !pre_evo.SpeciesCompatible?(move)

    pre_pre_evo = pbGetPreviousForm(pre_evo.species, pre_evo.form)
    if pre_pre_evo != [pre_evo.species, pre_evo.form]
      pre_pre_evo = PokeBattle_Pokemon.new(pre_pre_evo[0], 1, $Trainer, false, pre_pre_evo[1])
      return false if !pre_pre_evo.SpeciesCompatible?(move)
    end
  end
  return true
end

def isFormMove?(move, pkmn)
  return false if ![:ROTOM, :NECROZMA].include?(pkmn.species)
  if pkmn.species == :ROTOM
    return true if pkmn.form == 1 && move == :OVERHEAT
    return true if pkmn.form == 2 && move == :HYDROPUMP
    return true if pkmn.form == 3 && move == :BLIZZARD
    return true if pkmn.form == 4 && move == :AIRSLASH
    return true if pkmn.form == 5 && move == :LEAFSTORM
  end
  if pkmn.species == :NECROZMA
    return true if pkmn.form == 1 && move == :SUNSTEELSTRIKE
    return true if pkmn.form == 2 && move == :MOONGEISTBEAM
  end
  return false
end

def isSmeargleMove?(move, pkmn)
  return false if pkmn.species != :SMEARGLE
  return false if move == :CHATTER
  return false if $cache.moves[move].type == :SHADOW

  return true
end

def isLegalMoves?(pkmn)
  for i in 0...pkmn.moves.length
    for j in 0...i
      return false if pkmn.moves[i].move == pkmn.moves[j].move
    end
    if !pkmn.SpeciesCompatible?(pkmn.moves[i].move)
      next if isFormMove?(pkmn.moves[i].move, pkmn)
      next if isSmeargleMove?(pkmn.moves[i].move, pkmn)
      next if preEvoLearnsetCheck(pkmn.moves[i].move, pkmn)

      return false
    end
  end
  return true
end

################################################################################
# Level, IV, EV, and Item Check
################################################################################
def isLegalLevel?(pkmn)
  return false if pkmn.level < 1 || pkmn.level > 150

  return true
end

def isLegalIVs?(pkmn)
  pkmn.iv.each { |iv| return false if iv < 0 || iv > 31 }
  return true
end

def isLegalEVs?(pkmn)
  pkmn.ev.each { |ev| return false if ev < 0 || ev > 255 }
  return false if pkmn.ev.sum > 510

  return true
end

def isLegalItem?(pkmn)
  return true if !pkmn.item
  return false if $cache.items[pkmn.item].checkFlag?(:tm)
  return false if $cache.items[pkmn.item].checkFlag?(:keyitem)

  return true
end

################################################################################
# All of them (Form, Move, Level, IV, EV)
################################################################################
def isLegal?(pkmn)
  return false if !isLegalForm?(pkmn)
  return false if !isLegalMoves?(pkmn)
  return false if !isLegalLevel?(pkmn)
  return false if !isLegalIVs?(pkmn)
  return false if !isLegalEVs?(pkmn)
  return false if !isLegalItem?(pkmn)

  return true
end

def isLegalParty?(party)
  party.each { |pkmn| return false if !isLegal?(pkmn) }
  return true
end

################################################################################
# Nickname & etc Check
################################################################################
def nicknameFilterCheck(trainer)
  for pokemon in trainer.party
    name2 = pokemon.name
    name = (pokemon.name).downcase
    if !isLegalName?(name)
      print("An inappropriate nickname has been detected in your party. Please remove or rename #{name2} if you want to access online.")
      return false
    end
  end
  return true
end

def usernameFilterCheck(username)
  name = username.downcase
  if !isLegalName?(name)
    print("This username has been deemed inappropriate, please use another one.")
    return false
  end
  return true
end

def trainerNameFilterCheck(tname)
  name = tname.downcase
  if !isLegalName?(name)
    print("This trainer name has been deemed inappropriate, please use another one.")
    return false
  end
  return true
end

def isLegalName?(name)
  illegalname = [
    "bitch", "cock", "cumshot", "cunt", "fuck", "masturbation", "nigga", "nigger", "penis", "pussy", "slut",
    "twat", "vulva", "wank", "dick", "creampie", "morningwood", "piss", "pussies", "vagina", "cunny", "whore",
    "chink", "hitler", "nazi", "cum", "ballsack", "peniis", "thot", "dildo"
  ]
  return false if illegalname.any? { |word| name.include?(word) }
  return false if (name.include? "fag") && !(name == "cofagrigus") || name.include?('kum') && name != "pyukumuku" || name == "spic" || name == "kike"

  return true
end

def onlineNameChange
  oldname = $Trainer.name
  trname = pbEnterPlayerName("Your new name?", 0, 12, $Trainer.name)
  loop do
    if trname == ""
      Kernel.pbMessage(_INTL("Your name cannot be blank."))
      trname = pbEnterPlayerName("Your new name?", 0, 12, $Trainer.name)
    else
      break
    end
  end
  $Trainer.name = trname
  Kernel.pbMessage(_INTL("The player's name was changed to {1}.", $Trainer.name))
  for pokemon in $Trainer.party
    if pokemon.ot == oldname
      pokemon.ot = $Trainer.name
    end
  end
  for i in 0..34
    for pokemon in $PokemonStorage[i]
      next if !pokemon

      if pokemon.ot == oldname
        pokemon.ot = $Trainer.name
      end
    end
  end
  for i in 0..1
    pokemon = $PokemonGlobal.daycare[i][0]
    next if !pokemon

    if pokemon.ot == oldname
      pokemon.ot = $Trainer.name
    end
  end
end
