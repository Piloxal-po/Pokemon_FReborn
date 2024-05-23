GAMETITLE = "Pokemon Reborn"
GAMEFOLDER = "Reborn"
SAVEFOLDER = "Pokemon Reborn"

Reborn = true
Desolation = false
Rejuv = false
Gen7 = true

# Or 1161854567332450434 for testing
DiscordAppID = 929991753027711017

LEVELCAPS            = [20, 25, 35, 40, 45, 50, 55, 60, 65, 70, 70, 75, 75, 80, 85, 90, 90, 95, 150]
BADGECOUNT           = 18
STARTINGMAP          = 51
DEFAULTMONEYMULT     = 0

#===============================================================================
# * Mon Specific Map Data (for both evos and form encounters)
#===============================================================================

# Evos first
Crabominable = [
  364, 366, 373, 374, 375, 376, 377, 378, 379, 380, 384, 385, 386, 387, 388, 389,
  390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 430, 431, 432, 433, 434, 435,
  436, 439, 440, 441, 442, 457, 458, 459, 460, 461, 462, 463, 464
]
# Nosepass, Magnezone...
Magnetic = [197, 198, 281]
# Alolan/Galarian evos
Marowak = [152, 552]
Weezing = [793, 794]
Exeggutor = [
  15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 30, 31, 32, 33, 34, 35, 199, 200, 201, 202,
  203, 204, 205, 562, 563, 564, 565, 566, 567, 568
]
Raichu = [
  15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 26, 27, 30, 31, 32, 33, 34, 35, 199, 200, 201, 202, 203,
  204, 205, 206, 207, 208, 536, 538, 547, 553, 556, 558, 562, 563, 564, 565, 566, 567, 568, 569, 574,
  575, 576, 577, 578, 579, 586, 601, 603, 604, 605
]

# form encounters
MrMime = []
Shellos = [
  206, 513, 519, 522, 526, 528, 530, 536, 538, 547, 553, 555, 556, 558, 562, 563, 565, 566,
  567, 569, 574, 585, 586, 603, 604, 605, 608, 610
]
Deerling = [710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 742]
Rattata = [170, 524, 866] # and aMeowth!
Sandshrew = [
  364, 366, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384,
  385, 386, 387, 390, 396, 430, 433, 434, 440, 441, 442, 749, 750, 834, 882
]
Vulpix = [439, 721, 723, 725, 726, 727, 729, 794]
Diglett = [33, 34, 35, 199, 201, 202, 203, 204]
Geodude = [
  231, 247, 251, 258, 259, 260, 261, 262, 263, 264, 340, 341, 342, 343, 344,
  346, 347, 348, 349, 371, 614, 615, 616, 618, 847
]
Grimer = [
  467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481,
  482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497,
  498, 499, 500, 501, 502, 503, 504, 505
]
Cubone = [669, 880]
# form encounters - Sardines edit - data taken from MultipleForms.rb
Meowth = [] # gMeowth
Darumaka = []
Ponyta = []
Farfetchd = []
Zigzagoon = []
Yamask = []

Growlithe = []
Voltorb = []
Typhlosion = []
Qwilfish = []
Sneasel = []
Samurott = []
Lilligant = []
Zorua = []
Braviary = []
Sliggoo = []
Avalugg = []
Decidueye = []

DistortionWorld = [890, 891, 892]

#===============================================================================
# * Constants for maps to reflect sprites on
#===============================================================================

ReflectSpritesOn = [
  506
]

#===============================================================================
# * Constants for field differences
#===============================================================================

Glitchtypes = [:DARK, :STEEL, :FAIRY]
CHESSMOVES = [:STRENGTH, :ANCIENTPOWER, :PSYCHIC, :CONTINENTALCRUSH, :SECRETPOWER, :SHATTEREDPSYCHE]
STRIKERMOVES = [
  :STRENGTH, :WOODHAMMER, :DUALCHOP, :HEATCRASH, :SKYDROP,
  :BULLDOZE, :POUND, :ICICLECRASH, :BODYSLAM, :STOMP, :SLAM, :GIGAIMPACT, :SMACKDOWN, :IRONTAIL,
  :METEORMASH, :DRAGONRUSH, :CRABHAMMER, :BOUNCE, :HEAVYSLAM, :MAGNITUDE, :EARTHQUAKE,
  :STOMPINGTANTRUM, :BRUTALSWING, :HIGHHORSEPOWER, :ICEHAMMER, :DRAGONHAMMER, :BLAZEKICK,
  :GRAVAPPLE, :DOUBLEIRONBASH, :CONTINENTALCRUSH
]
TOTALFIELDS = 37

#===============================================================================
# * Two hashes for Variables and Switch names, in ascending order
#===============================================================================
Switches = {
  Seen_Pokerus: 2,
  Starting_Over: 5,
  Choosing_A_Starter: 28,
  Force_Weather: 151,
  Force_Wild_Shiny: 261,
  Fateful_Encounter: 262,
  No_Catching: 290,
  Riding_Tauros: 291,
  HearPinsir_Puzzle: 391,
  No_Mega_Evolution: 407,
  Has_PokeSnax: 414,
  Pulse_Evolution: 457,
  Rage_Powder_Vial: 463,
  Sleep_Powder_Vial: 464,
  Reborn_City_Restore: 479,
  Egg_Trade: 540,
  Wall_Smash: 568,
  Faux_Surf: 578,
  Pulse_Dex: 586,
  Field_Notes: 599,
  Retain_Surf: 649,
  Application_Applied: 715,
  Egg_Trade_2: 732,
  Anna_Smiles: 735,
  Devon_Panel_Switch: 745,
  Devon_Panel_Puzzle: 779,
  Get_A_Job_Quest: 783,
  No_Money_Loss: 789,
  No_Z_Move: 790,
  Cant_Surf: 850,
  Last_Ace_Switch: 1000,
  Magic_Square_Done: 1028,
  Dex_Quest_Done: 1043,
  Wing_Dings: 1060,

  Never_Escape: 1080,
  Show_Department_Card: 1097,
  Rock_Climb_Convenience: 1100,
  Stop_Icycle_Falling: 1106,
  VR_Gem3: 1179,
  Hard_Level_Cap: 1180,
  Exp_All_On: 1181,
  Stop_Arrows_Shooting: 1260,
  Pulse_Arceus: 1303,
  Disable_Quicksave: 1351,
  Battle_Tower_Doors: 1355,
  Grinding_Trainer_Money_Cut: 1356,
  Nuzlocke_Mode: 1357,
  Penniless_Mode: 1358,

  Randomized_Challenge: 1361,
  EasyHMs_Password: 1362,
  Just_Budew: 1365,
  Only_Pulse_2: 1368,
  No_Items_Password: 1369,
  Battle_Tower_FE_Enabled: 1376,
  Theme_Team_Execution: 1395,
  MnM_Execution: 1397,
  Blue_Orb_Quest: 1674,
  Rayquaza_Roam: 1870,
  Level_999: 1942,
  Disable_Signposts_Music: 2018,
  Empty_IVs_And_EVs_Password: 2038,
  Moneybags: 2039,
  No_Damage_Rolls: 2070,
  Full_IVs: 2076,
  Offset_Trainer_Levels: 2077,
  Percent_Trainer_Levels: 2102,
  Stable_Weather_Password: 2113,
  Overworld_Poison_Password: 2118,
  Empty_IVs_Password: 2119,
  Stop_Items_Password: 2120,
  Just_Vulpix: 2122,
  In_Battle: 2123,
  Stop_Ev_Gain: 2130,
  Cut_Convenience: 2132,
  Waterfall_Convenience: 2133,
  Surf_Convenience: 2134,
  Weather_password: 2149,
  Mid_quicksave: 2150,
  Rock_Smash_Convenience: 2152,
  Exp_All_Upgrade: 2155,
  A_Fervent_Wish: 2158,
  Gen_5_Weather: 2161,
  Inversemode: 2177,
  Unreal_Time: 2179,
  Free_Remote_PC: 2182,
  Flat_EV_Password: 2191,
  No_Total_EV_Cap: 2192,
  VR_Gem4: 2194,
  VR_Gem5: 2195,
  NB_Pokemon_Only: 2205,
  No_EXP_Gain: 2207,
  FirstUse: 2216,
  MiniDebug_Pass: 2217,
  FauxRiding: 2222,
  Discord_Spoilers: 2225,
  Blindstep: 2226,
  No_Puzzles_Pass: 2227,
  Doubles_Pass: 2230,
  No_Battles_Pass: 2232,
  Disabled_Randomizer: 2241,
  Max_Trainer_IVs_Password: 2244,
}
Variables = {
  Field_Effect_End_Of_Battle: 7,
  Field_Counter_End_Of_Battle: 8,
  Weather_End_Of_Battle: 9,
  Cave_Collapse: 10,
  Fossil: 16,
  Save_Slot: 27,
  Weather_Randomizer: 83,
  Current_Weather: 91,
  Weather_Override: 106,
  BattleResult: 117,
  E10_Story: 150,
  Player_Gender: 151,
  Forced_Field_Effect: 161,
  Player_Sprite: 176,
  Battle_Text_of_Opponent: 192,
  Next_Weather_Archetype: 317,
  Place_In_Weather_Pattern: 318,
  Party_Pokemon_Index: 344,
  Party_Pokemon_Name: 345,
  Starter_Quest: 438,
  Spirit_Rewards: 549,
  E4_Tracker: 552,
  Randomizer_Settings: 565,
  Randomizer_Seed: 566,
  Randomizer_Items: 567,
  Z_Cells: 590,
  Extended_Max_Level: 595,
  Theme_Team_Defeat_Line: 603,
  MnM_Defeat_Line: 608,
  Xernyvel: 660,
  Some_Bullshit: 675,
  Level_Offset_Value: 764,
  Level_Offset_Percent: 771,
  Set_Weather_1: 789,
  Set_Weather_2: 790,
  EncounterRateModifier: 794,
}

#===============================================================================
# * Message/Speech Frame location arrays
#=============================================================================

SpeechFrames = [
  "PRWS- speech1", # Default: speech hgss 1
  "PRWS- speech2",
  "PRWS- speech3",
  "PRWS- speech4",
  "PRWS- speech5",
  "PRWS- speech6",
  "PRWS- speech7",
  "PRWS- speech8",
  "PRWS- speech9",
  "PRWS- speech10",
  "PRWS- speech11",
  "PRWS- speech12",
  "PRWS- speech13",
  "PRWS- speech14",
  "PRWS- speech15",
  "PRWS- speech16",
  "PRWS- speech17",
  "PRWS- speech18",
  "PRWS- speech19",
  "PRWS- speech20",
  "PRWS- speech21",
  "PRWS- speech22",
  "PRWS- speech23",
  "PRWS- speech24",
  "PRWS- speech25",
  "PRWS- speech26",
  "PRWS- speech27",
  "PRWS- speech28"
]

TextFrames = [
  "Graphics/Windowskins/PRWS- menu1", # Default: choice 1
  "Graphics/Windowskins/PRWS- menu2",
  "Graphics/Windowskins/PRWS- menu3",
  "Graphics/Windowskins/PRWS- menu4",
  "Graphics/Windowskins/PRWS- menu5",
  "Graphics/Windowskins/PRWS- menu6",
  "Graphics/Windowskins/PRWS- menu7",
  "Graphics/Windowskins/PRWS- menu8",
  "Graphics/Windowskins/PRWS- menu9",
  "Graphics/Windowskins/PRWS- menu10",
  "Graphics/Windowskins/PRWS- menu11",
  "Graphics/Windowskins/PRWS- menu12",
  "Graphics/Windowskins/PRWS- menu13",
  "Graphics/Windowskins/PRWS- menu14",
  "Graphics/Windowskins/PRWS- menu15",
  "Graphics/Windowskins/PRWS- menu16",
  "Graphics/Windowskins/PRWS- menu17",
  "Graphics/Windowskins/PRWS- menu18",
  "Graphics/Windowskins/PRWS- menu19",
  "Graphics/Windowskins/PRWS- menu20",
  "Graphics/Windowskins/PRWS- menu21",
  "Graphics/Windowskins/PRWS- menu22",
  "Graphics/Windowskins/PRWS- menu23",
  "Graphics/Windowskins/PRWS- menu24",
  "Graphics/Windowskins/PRWS- menu25",
  "Graphics/Windowskins/PRWS- menu26",
  "Graphics/Windowskins/PRWS- menu27",
  "Graphics/Windowskins/PRWS- menu28"
]

VersionStyles = [
  ["PokemonEmerald"] # , # Default font style - Power Green/"Pokemon Emerald"
  # ["Power Red and Blue"],
  # ["Power Red and Green"],
  # s["Power Clear"]
]

PickupNormal = [
  :ORANBERRY,
  :GREATBALL,
  :SUPERREPEL,
  :POKESNAX,
  :CHOCOLATEIC,
  :BLASTPOWDER,
  :DUSKBALL,
  :ULTRAPOTION,
  :MAXREPEL,
  :FULLRESTORE,
  :REVIVE,
  :ETHER,
  :PPUP,
  :HEARTSCALE,
  :ABILITYCAPSULE,
  :HEARTSCALE,
  :BIGNUGGET,
  :SACREDASH,
]

PickupRare = [
  :NUGGET,
  :STRAWBIC,
  :NUGGET,
  :RARECANDY,
  :BLUEMIC,
  :RARECANDY,
  :BLUEMIC,
  :BIGNUGGET,
  :LEFTOVERS,
  :LUCKYEGG,
  :LEFTOVERS,
]

LEFT   = 0
TOP    = 0
RIGHT  = 14
BOTTOM = 18
SQUAREWIDTH  = 16
SQUAREHEIGHT = 16

#===============================================================================
# * Online BGM track names and locations
#===============================================================================
OnlineBGM = [
  ["Trainer 1", "Battle- Trainer.ogg"],
  ["Trainer 2", "Battle- Trainer2.ogg"],
  ["Trainer 3", "Battle- Trainer3.ogg"],
  ["Trainer Retro", "RBY Battle- Trainer.ogg"],
  ["Rival", "Battle- Rival.ogg"],
  ["Gym Leader", "Battle- Gym.ogg"],
  ["Gym Leader - Shade", "Battle- ReverseGym.ogg"],
  ["Gym Leader - Terra", "RBY Battle- Champion.ogg"],
  ["Meteor", "Battle- Meteor.ogg"],
  ["Meteor Admin", "Battle- Meteor Admin.ogg"],
  ["Upbeat", "Battle- Upbeat.ogg"],
  ["Dramatic", "Battle- Dramatic.ogg"],
  ["Misc", "Battle- Misc.ogg"],
  ["Wild 1", "Battle- Wild.ogg"],
  ["Wild 2", "Battle- Wild2.ogg"],
  ["Wild 3", "Battle- Wild3.ogg"],
  ["Wild 4", "Battle- Wild4.ogg"],
  ["Wild Retro", "RBY Battle- Wild.ogg"],
  ["Legendary", "Battle- Legendary.ogg"],
  ["Elite", "Battle- Elite.ogg"],
  ["Champion", "Battle- Champion.ogg"],
  ["Inner Peace", "Battle- Inner Peace.ogg"],
  ["Inner Chaos", "Battle- Inner Chaos.ogg"],
  ["Postgame", "Battle- Postgame.ogg"],
  ["Umbral", "Battle- Umbral.ogg"]
]

DISCORD_PLAYERS = {
  0 => "vero",
  1 => "alice",
  4 => "kuro",
  5 => "lucia",
  8 => "ari",
  9 => "decibel",
}

PULSEDexPictures = [
  [587, "navpulse00", "0. Garbodor", :GARBODOR, 1,
   "Produced by a curious stray Pokémon finding an abandoned machine. Its function is to make wasteful byproduct. Anything it touches sticks to it and will eventually be turned into toxic waste."],
  [588, "navpulse01", "1. Magnezone", :MAGNEZONE, 1,
   "The very first PULSE Pokémon created. Its function is mass reproduction. Each of its eyes contains the energy of one of the people responsible for its creation. It obeys only them."],
  [589, "navpulse02", "2. Avalugg", :AVALUGG, 1,
   "Created by a once wild Pokémon evolving in reaction to erratic energy. Its function is endless generation. Part of its body was formed around the machine, making it unable to move at all."],
  [590, "navpulse03", "3. Swalot", :SWALOT, 1,
   "Engineered to be totally indestructible. Its function is endless regeneration. When it expands its body, it loses consciousness, becoming only a vessel for absorption and subsequent expulsion."],
  [591, "navpulse04", "4. Muk", :MUK, 2,
   "Created by repeated fusions. Its function is systematic contamination. By becoming one with substances of any kind, it is able to transmute the target of its union into toxic filth."],
  [1778, "navpulse05a", "5A. Tangrowth", :TANGROWTH, 3,
   "Hybridized for erratic growth. Its function is to empower nature to reclaim stolen land. Its purification process is almost fully complete. At the end of its petrification, its organs also begin to harden and stop."],
  [1777, "navpulse05b", "5B. Tangrowth", :TANGROWTH, 2,
   "Hybridized for erratic growth. Its function is to empower nature to reclaim stolen land. After absorbing the latent corruption, it begins to purify the damage by petrifying and breaking down the toxic components."],
  [592, "navpulse05c", "5C. Tangrowth", :TANGROWTH, 1,
   "Hybridized for erratic growth. Its function is to empower nature to reclaim stolen land. Using long, reaching vines, it absorbs corruption from all sources into its body to dispose of it."],
  [593, "navpulse06", "6. Camerupt", :CAMERUPT, 2,
   "Created as a catalyst for purification. Its function is limitless amplification. Its body resonates with nearby heat, inciting reactive power. After eruption, it is unable to cool down, and will perish."],
  [594, "navpulse07", "7. Abra", :ABRA, 1,
   "An experiment testing the effects of PULSE systems on unevolved Pokémon. Its function is seamless transportation. Its body seems to reject all machine input, at the apparent cost of its psyche."],
  [595, "navpulse08", "8. Hypno", :HYPNO, 1,
   "Digitally lobotomized for full efficiency. Its function is perfect control. It projects its unconsciousness onto target locations and can directly manipulate up to two individuals at a time."],
  [596, "navpulse09", "9. Mr. Mime", :MRMIME, Gen7 ? 1 : 2,
   "Modified by repeated amputations and augmentations. Its function is impregnable defense. Its psychic power is amplified by the constant focus it requires to maintain control over its unattached limbs."],
  [597, "navpulse10", "10. Clawitzer", :CLAWITZER, 1,
   "Mechanically sculpted via scripted process. Its function is endless offensive potential. Many bodily features such as the brain have been rendered vestigial to allow manual usage of the Pokemon similar to traditional artillery."],
  [598, "navpulse11", "11. Arceus", :ARCEUS, 19,
   "World is deception, World is in pain, World should remake, World is competition, World is destruction, World is mistake, World is attack, World is unloved, World is deception, World is mistake, World is mistake, World is mistake, World is mistake"]
]

KNOWN_TRAINERS = {
  "Maxwell" => 6217,
  "Archer" => 45923,
  "Sanford" => 7056,
  "Sweet Co." => 14714,
  "Silph Co." => 23451,
  "Lady Arzzi" => 34567,
  "Corey" => 32574,
  "Elias" => 51242,
  "Agate Circ." => 30122,
  "Franz" => 35067,
  "Ms. Heidish" => 40673,
  "Ace" => 34071,
  "James" => 14253,
  "Bee" => 1021,
  "Taka" => 4102,
  "Noel" => 1164,
  "Nyu" => 25,
  "Mortin" => 43125,
  "Dahlia" => 17319,
  "Manuel" => 27016,
  "Kelly" => 16628,
  "Mickey" => 40804,
  "Ms. Linda" => 10468,
  "Eliza" => 18060,
  "Serena" => 58127,
  "Larry" => 19031,
  "Officer Jacob" => 25861,
  "Alan" => 28022,
  "Ms. LaRena" => 41191,
  "Carlos" => 55247,
  "Cpt. Florence" => 1397,
  "Eustace" => 16513,
  "Lillin" => 26806,
  "Myles" => 63794,
  "Felicia" => 31981,
  "Santiago" => 36105,
  "Arzelle" => 28136,
  "Mr. McKrezzy" => 47415,
  "Ashanti" => 30350,
  "Vermilion" => 16603,
  "Randall" => 17911,
  "Edie" => 49329,
  "Shade" => 26315,
  "Ame" => 9038,
  "Lizzy" => 44849,
  "Greg" => 25897,
  "Centennial" => 38261,
  "Marx" => 26801,
  "Weatherly" => 13619,
  "Alexander" => 2820,
  "Valerie" => 37235,
  "Vikki" => 28957,
  "Orlon" => 11050,
  "Emmy" => 39918,
  "Naini" => 58884,
  "Anderson" => 10289,
  "Monthelm" => 52035,
  "George" => 38484,
  "Irving" => 2899,
  "Officer Dane" => 33370,
  "Laura" => 35785,
}
