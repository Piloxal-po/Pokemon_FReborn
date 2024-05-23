#==============================================================================#
Pokémon Reborn
X-- Episode 19: Final --X
19.5.0-rc.5
http://www.rebornevo.com/
#==============================================================================#
This game contains some sequences with flashing effects, as well as mature content 
	and themes that may be unsuitable for some people, including death, child abuse, 
	sexual assault, blood and dismemberment. Please take care!


Pokémon Reborn is updated to Generation 7 only and uses 
	Ultra Sun/Ultra Moon learnsets and data.
#==============================================================================#

WINDOWS USERS: 
	To start the game, run Game.exe. 

LINUX USERS:
	To start the game, run Game.AppImage.
	In case it doesn't work:
	Install FUSE if you don't have it installed.
	Right click Game.AppImage, choose Properties > Permissions > Allow executing file as program
		OR
	Navigate to the directory via command line and run the following command:
		chmod +x Game.AppImage

MAC USERS:
	Move the game to the Applications folder before running the package.

JOIPLAY USERS:
	Use the Install Package option in JoiPlay.


Players continuing from E18 will begin the E19 story from Calcenon City.

If you find any bugs, please check for existing reports and post them at:
	http://www.rebornevo.com/forum/index.php?/forum/37-bug-reporting/

Community:
	Website				http://www.rebornevo.com/
	Discord Server		https://discord.com/invite/rebornevo
	Facebook			https://www.facebook.com/rebornevo/
	Reddit				https://www.reddit.com/r/Pokemon_Reborn/
	
	Patreon				https://www.patreon.com/amethystvl
		Please consider supporting our future projects~
	
	
#==============================================================================#
Table of Contents
#==============================================================================#
--- [I.] Notable Changes
--- [II.] Links
--- [III.] Controls
--- [IV.] Passwords
--- [V.] Troubleshooting
--- [VI.] Randomizer
--- [VII.] Credits
#==============================================================================#
[I.] Notable Changes:
#==============================================================================#

*	Many many bug fixes
*	Added built-in updater
*	The NewGame++ Mod has been integrated. Thanks, stardust!
*	Added experimental JoiPlay support
*	Favorite Items pocket
*	Improved keyboard & gamepad controls
*	Faster menu navigation using Home, End, Ctrl+Q/W/PageUp/PageDown
*	Added Discord integration
*	Added Portable Mode
*	Added Rainbow Scent key item
*	Added debug password
*	Added nopuzzles password
*	Added blindstep password
*	Added sound and animation to jumps
*	Added animation to rock climbs
*	Turbo speed is configurable
*	Evolution animation can be skipped
*	Field notes are now accessible during battle
*	Updated some shinies


#==============================================================================#
[II.] Links!
#==============================================================================#

Game home-page: 
			http://www.rebornevo.com/index.php?/pr/index.html/
			
Need help, found a bug, or want to share your team? Check out Pokémon Reborn's 
	discussion forum:
			http://www.rebornevo.com/forum/
			
The Pickup Table is different in Reborn. Check it here:
			http://www.rebornevo.com/index.php?/pr/pickup/
			
Other questions? Check the FAQ!
			http://www.rebornevo.com/index.php?/pr/gamefaq/
			
Chat on our Discord!
			https://discord.com/invite/rebornevo
			
Support development of future projects!	
			https://www.patreon.com/amethystvl
			
#==============================================================================#
[III.] Controls
#==============================================================================#

Press F1 to open the rebinding menu.

Keyboard:

Arrows: Move
C / Enter / Space: Interact, Select
X / Escape: Menu, Back, Skip Text
A: Mega, Z-Move, Sort, Misc.
S: Use Item, Battle Field Notes
D: Quick Save, Battle PULSE Notes
M / Alt: Toggle Turbo Mode
Shift: Toggle Run
Q / Page Up: Previous Page, Self Inspect
W / Page Down: Next Page, Foe Inspect
Ctrl + Q / W: Skip 10 pages up or down
Home / End: Jump to the first or last item
F1: Configure controls
F7: Mute, Unmute
F12: Soft Reset

Gamepad:

D-pad: Move
Cross / A: Interact, Select
Circle / B: Menu, Back, Skip Text
Square / X: Use Item, Battle Field Notes
Triangle / Y: Mega, Z-Move, Sort, Misc.
L2 (hold) / Back (toggle): Turbo Mode
R2 (hold) / Back (toggle): Run
L1: Previous Page, Self Inspect
R1: Next Page, Foe Inspect
R2 + L1 / R1: Skip 10 pages up or down
Left Stick: Mute, Unmute
Right Stick: Quick Save, Battle PULSE Notes
Guide: Soft Reset

#==============================================================================#
[IV.] Passwords
#==============================================================================#

At the start of the game, you will be prompted for special instructions, or
passwords. Below is a list of applicable passwords. 
Please note that these are features are considered a bonus, and may have some 
unexpected interactions at times...

Implement a hard EXP cap when maxed on badges, similar to Pokémon Rejuvenation:
	Password: hardcap

Cause randomized early game Pokémon events to bias towards a specific type:
	Password: mononormal
	Password: monofire
	Password: monowater
	Password: monograss
	Password: monoelectric
	Password: monoice
	Password: monofighting
	Password: monopoison
	Password: monoground
	Password: monoflying
	Password: monobug
	Password: monopsychic
	Password: monorock
	Password: monoghost
	Password: monodragon
	Password: monodark
	Password: monosteel
	Password: monofairy

Prevent Pokémon from being healed after their HP drops to 0:
	Password: nuzlocke
	
Randomly reshuffles species and moves as rolled at game start:
	Password: randomizer
	
Pokémon do not need to know HM (TMX) moves in order to use them in the field:
	Password: easyhms
	
Prohibits the player's use of items in trainer battles:
	Password: noitems
	
Sets all opposing trainer Pokémon to have 252 EVs and 31 IVs in all stats:
	Password: fullevs
	
Sets all opposing trainer Pokémon to have 0 EVs and IVs in all stats:
	Password: litemode
	
Makes all Field	Notes visible immediately
	Password: allfieldapp
	
Remove some randomness by making all attacks do consistent damage rather than a roll:
	Password: nodamageroll
	
Enable audio accessibility features for visually impaired players (partial support only):
	Password: blindstep
	
Multiple passwords, including differing monotypes, may be used in tandem with 
each other, but progress at your own risk~

Other hidden passwords may be able to be found in the game.
	
#==============================================================================#
[V.] Troubleshooting
#==============================================================================#

WINDOWS:

	Issue: 
		"Error creating OpenAL context"
	Fix:
		The game is trying to play audio, but can't.
		Make sure a valid audio device is plugged in. 
		
		
	Issue: 
		The screen is black, or only works in Medium size.
	Fix: 
		Open NVIDIA Control Panel from the Desktop
		Go to 3d Configurations > Program Specific
		Add Pokemon Reborn Game.exe, choose Antialiasing FXAA and set to Enabled.
		
	
	Issue: 
		"A graphics card that supports OpenGL 2.0 or later is required."
	Fix:
		You desperately need a modern GPU, OR you have a GPU which Windows 10 discontinued OpenGL support for.
		Some players have had luck with this video: https://www.youtube.com/watch?v=Yqe5cgthZH4
		However, in most cases you will need to install Linux on an external drive and play the game via Linux.
		Sorry, we don't like this either, blame Microsoft :C
		
		
		
MACINTOSH:
			
	Issue:
		Cannot open Data/Scripts.rxdata
	Fix:
		Make sure you're running the game from Applications folder. 
		This works for almost every case, but if it is not working, instead try running from the Desktop folder.
		Alternatively, if you are on an M1 click, view App Info and tick the checkbox to open with Rosetta.
		
		
#==============================================================================#
[VI.] Randomizer
#==============================================================================#

Here is an in-depth breakdown of all present options in the Randomizer.
You can search them by using the tab header as they appear in game or through letters [a-i.].
All loggable changes on a save will be saved as a text file in the Randomizer Data directory.

To condense the list, the Follow Evolutions option for many different traits will dictate whether 
the changes to the pre-evolution will apply to all further evolutions. Split evolutions will have
completely new traits, but always share at least one of their types.

	[a.] Species Traits
		Base Stats:
			Random - Randomly assigns new base stats where each stat is weighted based on the original stat percentage.
			Shuffle - Takes the current base stats and shuffles the order. Attack may be the new Speed, Defense may be the new HP.
			Flipped! - Follows the Flipped! OM on Smogon. Flips the base stats so HP <> Speed, Attack <> Special Defense, Defense <> Special Attack.
		Abilities:
			Each Pokemon receives 3 random abilities.
			Allow Wonder Guard? - Allows the generation of the ability Wonder Guard.
			Ban Trapping Abilities - Prevents the generation of abilities such as Arena Trap or Shadow Tag.
			Abilities that impose restrictions (Stall, Slow Start, Klutz) will not generate.
		Types:
			Generates 1-2 new types.
			Dual Type Chance - The percent chance to generate a second type.
	[b.] Evolutions
		Each Pokemon will have one evolution. All non-level based evolutions are changed to level based on BST
		of the Evolution.
		Force Different? - Prevents generation of evolutions that already exist.
		Limit Evolutions? - Prevents evolutions from potentially having no end or having more than 2 evolutions
		Same Typing? - Forces evolution to have the same typing, provided sufficient valid picks still exist.
		Similar Strength? - Forces evolution to have a similar BST as the original, provided sufficient valid picks still exist.
	[c.] Move & Movesets
		Move Data:
			Typing - Randomly assigns new types to all moves. There is a hidden setting in Scripts/Randomizer/RandomizerSettings 
			that will change move names to match their new type as well!
			Base Power - Randomly assigns new base power to moves. Usually assigned from 50-100, small chance for 20-150, even smaller chances
			for moves to gain +50 or +100 base power.
			Accuracy - Randomly assigns new accuracies to moves. Typically within 20 accuracy of the base move, and moves with less than
			50 accuracy have a small chance to receive a slight boost.
			Move Category - Physical/Special will be randomly generated.
		Movesets:
			Random - Completely random selection of moves
			Prefer Type - Generates new movesets, influenced by the Pokemon's typings.
			Metronome - All Pokemon only learn Metronome.
			Force Good Move % - Ensures a certain percentage of the new moveset is greater than 70BP.
			Scale Moves with Level - Rearranges the moveset so lower BP moves are learned first and higher BP moves are learned last.
			Ban Set Damage Moves - Prevents generation of Dragon Rage and Sonic Boom
			Learn Moves On Evolution? - Adds an evolution move to every Pokemon
	[d.] Encounters
		Encounter Options:
			Random - Completely random Pokemon every time.
			Area - Each route has the same set of random Pokemon each time.
			Global - Each Pokemon will generate into a set Pokemon every time.
		Similar Strength? - Matches the encounter to one with a similar BST.
		Match Types? - Ensures Pokemon have the same type as the original encounter. This will be removed later in favor of type theming areas.
		Dsiable Legendaries? - Prevents Legendary Pokemon from generating.
		Starters:
			Randomly assigns replaces each starter with a new Pokemon. These can be legendaries.
			Option to force starters to have 2 evolutions.
		Have static Pokemon randomize - Pokemon directly given to you, including eggs, will be completely random.
	[e.] Trainers
		Have all trainers randomize - Trainers will have completely random Pokemon.
	[f.] TMs & Tutors
		You will not have moves needed for progression randomize, or appear before/after you're intended to get them through these options.
		Both options have the same descriptions:
			Randomly generated moves, with their graphics and other display information being properly updated on TMs.
			Compatibility:
				Unchanged - If a Pokemon could learn the old move, it can learn the new one.
				Random - Completely randomized compatibility
				Type - Randomizes compatibility based on the move type and Pokemon type. Each type should learn the majority of similarly typed moves,
				Normal types get about half of all non-Normal type moves, and a low chance to learn moves that don't match.
				Full - All Pokemon learn every move.
			Force Good Move % - Ensures a certain percentage of moves generated contain a move with at least 70BP.
	[g.] Items
		You will not have items needed for progression randomize, or appear before/after you're intended to get them through these options.
		Field Items:
			Procedurally generates items as you obtain them.
			Option to ensure the item would be the same type of item.
		PokeMarts:
			Randomly generates a new shop for each shop.
			Option to ensure the item would be the same type of item.
	[h.] Types
		Allow ??? Type? - Allows the ??? type to generate for Pokemon or Move typings.
		Allow Shadow Type? - Allows the Shadow type to generate for Pokemon or Move typings.
	[i.] Misc Settings
		Allow Mega Pokemon? - Allows static Mega Pokemon to generate as encounters or evolutions that do not revert after battle.
		Allow Trainer Esclusives? - Allows unobtainable Pokemon that do not appear in the Pokedex to generate as encounters or evolutions.

		
#==============================================================================#
[VII.] Credits
#==============================================================================#
If we've missed your contribution, please feel free to contact us so we can fix 
	that!
	
Pokémon Reborn is created using RPG Maker XP and the Pokémon Essentials Starter Kit. 
Pokémon Reborn does not claim ownership of Pokémon or any associated content.
All original characters, artwork and other media remain the property of their respective authors.	

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Core Development
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Amethyst 		
		https://twitter.com/amethystvl
		https://amethystblack.tumblr.com/
		http://twitch.tv/amethystblack			
andracass					
Ikaru						
Autumn						
Marcello			
		https://twitter.com/MarcelloMaths			
Smeargletail				
VulpesDraconis
		https://twitter.com/VulpesDraconis	
Toothpastefairy
Crim
		https://twitter.com/crimcrimart
Azzie


--Ongoing Development:
Amethyst
enumag
Haru
Lucent Flash
Stardust
Cad48

--Prior Developers:
Kurotsune
Blind Guardian
Guhorden
Mike
Walpurgis
Mde2001
Azery
Kanaya
Jan
Koyoss

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--World, Characters & Concept:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Amethyst 	
--Additional Characters:
Will Dodge		Ice		Crim
--PULSE Designs:
Crim		Sleppu

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Tilesets & Mapping:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Amethyst
Crim
Smeargletail
-- Mapping Support 
Ikaru 		Autumn		Kanaya 
-- Tilesets:	
Pokémon Essentials
princess-phoenix
		
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Sprites:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Amethyst	
Crim
Jan	
--6th Gen Battlers:
Amethyst	Noscium			Quanyails		Zermonious		GeoIsEvil		
Kyle Dove	dDialgaDiamondb		N-kin		Misterreno		Kevfin
Xtreme1992	Vale98PM 		MrDollSteak		Crim

--7th Gen Battlers:
Amethyst		Jan			Zumi			Bazaro			Koyo	
Smeargletail	Alex		Noscium			Leparagon		N-kin	
fishbowlsoul90	princess-phoenix		DatLopunnyTho		Conyjams 	
kaji atsu 		The cynical poet	LuigiPlayer		Pokefan2000
Falgaia of the Smogon S/M sprite project	Lord-Myre 		Crim

--Mega Sprites: 
Amethyst	Bazaro			Gardrow			FlameJow		Minhnerd	
The Cynical Poet			Greyenna		Brylark			Leparagon	
Princess Phoenix			Gnomowladn		Bryancct		Tinivi
Julian	Dante52		Crim

--Icons:
smeargletail	ARandomTalkingBush

--Miscellaneous Sprites:
Will		Veenerick		chasemortier	Mektar (Pokémon Amethyst)	
JoshR691	kidkatt			ShinxLuver		Dr Shellos		Getsuei-H
Kidkatt		Nefalem			Piphybuilder88		SageDeoxys
PurpleZaffre

--Shiny Spriting:
Amethyst	UnprofessionalAmateur	Nefalem		Jacze	Freya
Calvius			Flux	Thirdbird	Mike		Bazaro	Azery
Bakerlite		Gamien	Rielly987	smeargletail	Nsuprem
15gamer2000		dragon in night		Nova		Night Fighter
Serythe		MetalKing1417	roqi	Jan			MMM		Kelazi5
Player_Name_Null	Khrona 		Sir_Bagel	Pixl	Crim 
ghostchanuwu

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Animations:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Smeargletail
Mde2001
Autumn
VulpesDraconis
Amethyst
Crim
andracass
Koyoss
Jan
--Sound:
Pokémon Mystery Universe	
Amethyst
--Original Rip:
Neslug		
					
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Programming:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
andracass
Toothpastefairy
Marcello
Amethyst
Kurotsune
Blind Guardian
Mike
Azery
Walpurgis

--External Scripting Support:
Woobowiz	FL				XmarkXalanX		JV			madf0x
Joeyhugg	Nickaloose 		mej71		Suzerain 		Rayd2smitty
Beba 		worldslayer89	the dekay	saving raven	Truegee
Wootius		Waynolt			AiedailEclipsed		enumag	KleinStudido
Aeodyn 		bluetowel 	Rainbow Dash	Nuems	Olxinos

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Scenario & Eventing:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Amethyst
Crim
Smeargletail
Marcello

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Writing:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Amethyst
Azzie
andracass
Marcello
Crim

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Battle Design:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
andracass
Amethyst
Autumn
Crim

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Sound & Music:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Featuring GlitchxCity ( http://www.youtube.com/user/GlitchxCity )
Amethyst
--Guest Composers:
Dragon-Tamer795		O Colosso		RichViola		Darius
djtheS

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--External Resources:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Phasma 		SunakazeKun	
--Tile Puzzle Artists:
germy21 (Swirlix)				Macuarrorro (Spritzee)
Ramiro Maldini (Conkeldurr)		Otonashi (Froakie)
iamherecozidraw (Carracosta)	syansyan (Archeops)
Sires J Black (Turtwig)
--Rock Climb Animation:
Ulithium_Dragon		DarrylBD99
-- Accessibility Sounds:
aaron_vgstorm

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Community Support:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
bluebomberdude		Ikaru		zelient		Jacze		Flux
jeroen4923			Khayoz		Cobrakill	Ryan C		Cowtao
Manes				Calvius			garchomp550		MattMadnesS
Guigui			DarkLucario79		grasssnake485		Acquiescence
SonOfRed			Rimmintine	Arkhidon	Mike		Tacos&Flowers
Vinny				chase_breaker	Sheep!	Kalzuna		Pyrolusite
Alex			cybershell12		BIGJRA		Haru	TheInsurgent
Stardust		housecarpenter		rainefall
Many, many, many more!

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Community Cooperation Initiative:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Alemi	Aqib	Pixel	Dred

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Meme Consultant:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Autumn

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Quality Assurance: 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Thanks so much to the community and our supporters for all the care and 
	patience demonstrated with testing and reporting issues over the years!
--On-board QA:
	Ikaru
--Supervised Guinea Pigs:
	Ikaru
	Autumn
	Blind Guardian						

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Pokémon Essentials:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Maruno		Poccil		Flameguru		

--With contributions from:
AvatarMonkeyKirby		MiDas Mike		P.Sign		Boushy		
Near Fantastica 		Brother1440		PinkMan 	FL.		
Popper		Genzai Kawakami		Rataime		Harshboy 	SoundSpawn
help-14		the__end	IceGod64	Venom12		Jacob O. Wobbrock
Wachunga	KitsuneKouta		xLeD		Lisa Anthony
And everyone else who helped out
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--MKXP Support:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Inori		Ancurio

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
-- Supporters <3
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Tartar		Robert Lou		Luis C. Morales		Michael Manning
Hachilio (Busti)			Dragon116		Reni Donovan
Zumi		Anna Zajac		Leon Janßen		Yannik Thiele
Daan Karma	Simon Khoang	Franz Reimer	Nelio Alves
chranokil	Thamos Spanu	Jan				Paul Steinbrück
Peanuts		Noir			Ramiru			Jacob
Dillon Holmes		Pascal P. 	Fullmoon	Layla K
Cameron Andrews		Marshall Mann	Will Dodge		Naoman Arif
Jakob Thaler		Thomas Landauer		Erikaru		Robin
Daniel McCormick	Eric Therrien		Hoodless	Mey
Spencer Basinger	Sean	Jim Knicker, Ace detective		Nicky
Tom Hobbs		Gredler Andreas		Christian Casanova		Sardines
Shamish Sergey		Juan Hildago Arancibia		Casim Bahadar
Winter		CrossImpact		Joonas Kivi		Gabby		Hammertime
Elin Ölund Forsling			aspectoflife		Budew........
ChaosReaperPein		Addi Sanders		Candy
whomst'd'ven't		Vatelin			Ania Zajac		Geoffery Nelson
The Drunken Dragonite		lilbegestjake		Shadowstar
Noivy		AiedailEclipsed				isognio 	aries
cakeofdoom		Jonatas		Matt Shephard 		ssbCasper
Winter Erikson		Alistair		Alexandre Eira
Kouhai Xmas		TharTV		Leo	ogur0007
Friz		Ama			Zarc		Outside Indoorsman
cybershell12		Wossad		herbuhduhflergen 	2moe4this
Sir Issac		DiLimiter			Elkhen		The Bells Toll
Aal		steelpenguins		RockInTheDark	keyblade336
Kero Kanyo		Zargerth		It's Still Magicarp Inside
Hark		Awbawlisk 		Jompa		Jay Taylor
Red Tyranitar		Pietvergiet		Splargle		Nakoles
shteve		ridiculus		Nisa Bernal 		riceinabowl
Elite Four Daniel		Ninjaneois		Inmperial		Zanshouken
Magraga		Semiramis		Masked Aura		Reignited'Light
Tacos&Flowers	Joshuar_00	punkeev softpaws steffi	EdgarHasFreed
Ross_Andrews	GS Ball		Syglory		About 42 Bears
DefaultDevers	Blaze_Lumini		Sham (Wilson)
RocketRiddle	SkabbtheHunter109 	Dasuper11		SmK
Potwom		McZ		Tempest		Nadrel		BLaZn
Andrew Parekh		Mastercatcher00X	ProjectIceman
Kevin Silva		Lucent Flash 		andracass		BIGJRA
Archinblade3	Launce		Dark_Absol		CielDiVine
Posty		Valerie		Mimon Hamed Mohamed 	E.L.Y
RubyRed		chaoticangel97		Kirixah
Trevore		Aldrich Faithful		Apostolos Palavras
Winter Angel		MarsupialJr		jaden582
BigShotJoe		JapaneseWallpaper		Azery
TU84		Ghost141		Foster Davis	Mayflower896
Ceratisa		Zorekky 		Ryan Stiles
Zeroyue			advesha		ToDie		Yumi_uwu
Lily Awaka		Kevin O'Keeffe			Bryan Barlitt
Pyroclast		Colette			lavalampflamingo
Zoey Elaine Greer		Alva Akasha		Blind Guardian
Paul White II		Goldjoz			Rising Sun Reviews
Raphael Soares		Spika Patate		Chameleon109
boomdiada		Just Yes		Boiger		derpingmudkip
Jetasd		Matt Pissaris		Kamu		Abyssreaper99
TurtleBear		bubblegum		Ctracha		Zack Fair
FloRoux		Endstrom		tektonic	Eirik Graves
Azzie		klover47		BlazingAngel123
EternalLight95		Birb		Taranis Blackstorm
DrGustave		RedLumain		Mason Graves
Monkeydog		Anthony Laster		pjplatypus
Malignant		Vanner		Epharam		qwop9992
hamfam000		CharredBrown		Kim Rinaldo
Artstyle		Lua			LisaX 		~(^.^)~
pyrostar		Cad48		Alex Rose		lester tay
Tibi Radu		pyrromanis		ShiroOkazaki
steelpenguins	iMadMatthew		Fehish		ajefk12555
3333percent		bluetowel		Ryan Beaulne		J P
Odis		Tate Hamilton	Alexander Dean		
Kyublivion 	Victorywithice		Shad0		Logintomylife
Elijah		Ditiamed		LeoYT		Motoko
Joboshy		Crim		Hachimaki		KORMA
Rob28		Michael Miranda		Blazerburst		Cyrikyty
JB		hcsa		Youkai Nep		Logan the balalaika
Kithas		Bellona et Pax		camelCaseD		Joseph Torres
Wolfox		Liam Lucas		Bellona			Seal
zervixen		GeoEngel		radoslav573			Felicity
Alexis Bernatchez Verville			Sean		Stordeur
Christopher Horon 		Nerozard22			Chris
Lukan Hardin		Arthur Rouillé		Bjarne Nehring
Spoon		Wyliewb13			Seyon		Joshua2200
Lloyd Hale		Riley Maxwell Somers		Alex Schiavetto
Gawerty		CeriseBlossom		Beck		Fawn
Ryan Nasser			Baraayas		Ron		UptonPickman
alex goerz 		Jacob Deutsch		Adam A		Fenceperson
Kyle		ShinyBlade		Sethur		Aman Didwania
Emmett Gaiman		DDBlue666		Thomas
Habbo		jenna jonica		Jac		BeoWulf
Alexander Kozlov	 maxime busc		Jacob Metzker
Chase		Sakura Sis 		Frostiliscious		PaulMSZ-006
Christopher Chambliss		Meridian		Dewfall
Tom Hobbs			William Minnimin		enumag
Vicky Chen		Megan Blincoe		Cuddles		Cameron Mcevoy
Eevee 		Anthony Szmyhol			Drakyle			Greg
Shane Zoppellaro		Artist		foamy		crispy
Dream		Aurora		Sage TheRoserade		Bruno Macedo
Bassem		Captain Momo		Tim I		Adrien Lange
Veno Zen		Yeicx		Henry Nguyen		Ian McSweeney
John Thillted Jr		Namelesssimp		Georginio Lois
Pedro Villar		Sinikuro			Evan Gross		alec joseph
Pacifist Games		Ruthger Dijt		A		Geoffrey Chen
spleen17		Joel Woolley		Forneus		simon anderson
AyTales		mortifiedbitch		Fiwam		FunnyBone48
Saraphimwolf		Azrael		evilginger27		NS Flash-Fire
Matty		Lindinator666	Fezzdog		Nick D			王 サゲル
Ainsley Robbins		Spiff		Mahendran		Katurayan
Michal		Raven Dragon		Tom Sayer		Haze
Kino		enzzzzzz		Josh Peck		Macspie
Ben Knight			Dan		violet thunder		Ngoc Nguyen		Tim
OverlordMatt

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
--Special Thanks:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
-- STK Patrick for sparking the project in the first place!
-- To all of the Reborn Line Leaders over the years for helping kick this all off!
-- All current and former community staff for helping keep things sane...
-- The community as a whole for being so engaged and lively!
-- Shout out to all of the lovely patrons for making this happen!
-- Nintendo for not sniping us dead before we could finish?
-- A very special UN-thanks to the jerk who lied to me as a kid and swore that you could get to the Orange Islands in Crystal Version!!! Boo!!!
-- And finally, thanks to YOU for playing and making it all the way here!
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
