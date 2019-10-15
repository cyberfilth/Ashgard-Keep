extends Node

# Name for evil mage
const MAGE_FIRSTNAME = ['A', 'Ag', 'Ar', 'Ara', 'Anu', 'Bal', 'Bil', 'Boro', 'Bern', 'Bra', 'Cas', 'Cere', 'Co', 'Con',
	'Cor', 'Dag', 'Doo', 'Elen', 'El', 'En', 'Eo', 'Faf', 'Fan', 'Fara', 'Fre', 'Fro', 'Ga', 'Gala', 'Has', 
	'He', 'Heim', 'Ho', 'Isil', 'In', 'Ini', 'Is', 'Ka', 'Kuo', 'Lance', 'Lo', 'Ma', 'Mag', 'Mi', 'Mo', 
	'Moon', 'Mor', 'Mora', 'Nin', 'O', 'Obi', 'Og', 'Pelli', 'Por', 'Ran', 'Rud', 'Sam',  'She', 'Sheel', 
	'Shin', 'Shog', 'Son', 'Sur', 'Theo', 'Tho', 'Tris', 'U', 'Uh', 'Ul', 'Vap', 'Vish', 'Vor', 'Ya', 'Yo', 'Yyr']
const MAGE_SECONDNAME = ['ba', 'bis', 'bo', 'bus', 'da', 'dal', 'dagz', 'den', 'di', 'dil', 'dinn', 'do', 'dor', 'dra', 
	'dur', 'gi', 'gauble', 'gen', 'glum', 'go', 'gorn', 'goth', 'had', 'hard', 'is', 'karrl', 'ki', 'koon', 'ku', 
	'lad', 'ler', 'li', 'lot', 'ma', 'man', 'mir', 'mus', 'nan', 'ni', 'nor', 'nu', 'pian', 'ra', 'rakh', 
	'ric', 'rin', 'rum', 'rus', 'rut', 'sekh', 'sha', 'thos', 'thur', 'toa', 'tu', 'tur', 'tred', 'varl',
	'wain', 'wan', 'win', 'wise', 'ya']
const TITLE = [' the Ancient',' the Polluted',' the Insane',' the Betrayer',' the Afflicted',' the Slayer',' the Broken',\
	' the Reviled',' the Conqueror',' the Unwise',' the Malignant',' the Aged',' the Impure',' the Mad',' the Tyrant',\
	' the Vain',' the Destroyer',' the Hateful',' the Scourge',' the Bloody']

# Name for Dwarven clan
const CLAN_FIRSTPART = ['Iron','Rock','Dark','War','Grim','Rune','Storm','Frost','Thunder','Bright','Blood','Grey',\
	'Stone','Bronze','Silver','Bone','Ice','Fire']
const CLAN_SECONDPART = ['Axe','Hammer','Anvil','Smith','Forge','Beard','Shield','Biter','Bane','Weaver','Mage','Spear',\
	'Seeker','Sword','Crafter','Fist','Smasher','Rage','Tooth']

# Name of religious order
const PAL_ADJECTIVE = ['The Bright ','The Shining ','The Just ','The Golden ','The Silver ','The Exalted ']
const PAL_OBJECT = ['Sword of ','Shield of ','Order of ','Dawn of ','Brotherhood of ','Heralds of ','Legion of ',\
	'Torch of ']
const PAL_NAME = ['Adalm','Adena','Adre','Adricelory','Amarist','Amberryn','Ambika','Ambika','Ara','Ara-To','Balaar',\
	'Berdrak','Berial','Berlosz','Berlsa','Berrionne','Bry','Calla','Carcedda','Cashath','Casonia','Chath','Cyn',\
	'Cyna','Cziara','Dabikkon','Dara','Daras','Delorest','Desdoniann','Deva','Domna','Domnash','Drukkor','Handrekka',\
	'Handrist','Heddarcelo','Jetinta','Jetta','Joba','Kalla','Kalliandra','Kallianta','Kalline','Keelia','Keellia',\
	'Keelor','Kerz-anta','Killia','Killia','Koresdony','Kory-antia','Lyssandra','Maurak','Riondrist','Riony','Salanne',\
	'Sidomina','Sidona','Sidondracci','Sirdre','Solia','Tempes','Tria','Vala','Vallia','Vallie','Vallith','Winiaz']

# Elven city
const ELF_NAME1 = ['the Vale of ','the Whispering Forest of ', 'the forest of ', 'the white peaks of ','the woods of ',\
	'the Cinderlands of ','the Frostspike of ','the snow pass of ','the green fortress of ','the Waterways of ',\
	'the sorrowful streams of ','the Whispering Glade of ','the Hidden Spires of ','the Shimmering of ']
const ELF_NAME2 = ['Felamae','Lorrom','Anorel','Weneres','Rathel','Lasbreg-Dwyr','Renamar','Sarriel','Vius','Viusand',\
	'Ethgal','Renfin','Syldar','Thrantor','Paceledrel','Borntae','Mai-Ionla','Marrion','Thorndal','Ladkur','Imorvo',\
	'Rescir','Godan','Vadan','Daggil','Saner','Evnall','Lexa','Alta','Lorandwyr','Saand-Riel','Mardír','Dorril',\
	'Thallor','Wingdal','Duil','Glanduil','Iliphar','Ilrune','Saleh','Urijyre','Inamys','Caiwraek']

# Greenskins
const GOBLIN_NAMES_1 = ['Barrg','Bolguh','FishSquish','Gobarrg','Gobbler','Grunsch','Lugnutter','Lulz','Mogger',\
	'NosePicker','Orbash','Slobber','Snaggle','SnotFlinger','Squelch','Stabber']
const GOBLIN_NAMES_2 = ['Booger','Drooler','PigSpit','Pukey','Ratskinner','Scumrot','Sniffler','Stinker','Stinkrot','Swampy','Tintooth','ToadLicker','Wiggler']
const GOBLIN_TITLES = [' the goblin janitor', ' the goblin smuggler', ' the rat-catcher',' the goblin sewer-worker',\
	' the goblin assassin',' the goblin gigalo',' the goblin pirate' ]

# Trolls
const ROCK_TROLL_NAMES_1 = ['Quartz','Tuff','Shayull','HornFell','Ignatius','Chalky','Skarn','Flint','Kaleesh',\
	'RhyoLite','Chert','Soapy','ClayFoot','Grit','IronStone','Shingle','Chip']

# Player names - pseudo-Markov chain
var markov_names = ['Adara', 'Adena', 'Adrianne', 'Alarice', 'Alvita', 'Amara', 'Ambika', 'Antonia', 'Araceli', 'Balandria', 'Basha',\
'Beryl', 'Bryn', 'Callia', 'Caryssa', 'Cassandra', 'Casondrah', 'Chatha', 'Ciara', 'Cynara', 'Cytheria', 'Dabria', 'Darcei',\
'Deandra', 'Deirdre', 'Delores', 'Desdomna', 'Devi', 'Dominique', 'Drucilla', 'Duvessa', 'Ebony', 'Ezzuh', 'Eohda', 'Fantine',\
'Fuscienne', 'Farsha', 'Gabi', 'Gallia', 'Grokk', 'Hanna', 'Hades', 'Hecate', 'Hedda', 'Hermes', 'Iona', 'Irrin', 'Idriss',\
'Jerica', 'Jetta', 'Joby', 'Kacila', 'Kagami', 'Kala', 'Kallie', 'Keelia', 'Kerry', 'Kimberly', 'Killian', 'Kory', 'Lilith',\
'Lucretia', 'Lysha', 'Mercedes', 'Mia', 'Maura', 'Noah', 'Nikolai', 'Nemura', 'Osiris','Odama', 'Odysseus','Orin', 'Perdita',\
'Paris', 'Penia', 'Phaeron', 'Poseidon', 'Quella', 'Quistis', 'Quarg', 'Quasimodo', 'Rain', 'Roma', 'Riona', 'Safiya', 'Salina',\
'Severin', 'Sidonia', 'Sirena', 'Solita', 'Tempest', 'Thea', 'Treva', 'Trista', 'Thrasos', 'Unther', 'Unferth', 'Vala', 'Vailon',\
'Winta', 'Wiglaf', 'Xarka', 'Xena', 'Yuzz', 'Yara', 'Zakarr','Zarathustra']
var player_suffix = [' the Brave', ' FleetFoot', ' the Stoic', ' Orc Bane', ' the Fair', ' Babyface', ' the Just', ' RuneSmith',\
' the Green', ' AleFiend']
var alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
var markov = {}
var username

var mage
var npc_greenskin1
var npc_greenskin2
var npc_rock_troll1

func generate_plot():
	mage = MAGE_FIRSTNAME[randi() % MAGE_FIRSTNAME.size()] + MAGE_SECONDNAME[randi() % MAGE_SECONDNAME.size()] + TITLE[randi() % TITLE.size()]
	npc_greenskin1 = GOBLIN_NAMES_1[randi() % GOBLIN_NAMES_1.size()] + GOBLIN_TITLES[randi() % GOBLIN_TITLES.size()]
	npc_greenskin2 = GOBLIN_NAMES_2[randi() % GOBLIN_NAMES_2.size()] + GOBLIN_TITLES[randi() % GOBLIN_TITLES.size()]
	npc_rock_troll1 = ROCK_TROLL_NAMES_1[randi() % ROCK_TROLL_NAMES_1.size()] + " the Rock Troll"
		
	# Player name
	loadNames(markov, markov_names)
	var new_name = ""
	for i in range(1):
		var random_letter = alphabet[GameData.roll(0, alphabet.size()-1)]
		new_name = getName(random_letter, 4, 7)
		new_name = new_name.capitalize()
		username = new_name+player_suffix[(randi() % player_suffix.size())]
#	var dwarf_clan_name = CLAN_FIRSTPART[randi() % CLAN_FIRSTPART.size()] + CLAN_SECONDPART[randi() % CLAN_SECONDPART.size()]
#	var paladin_order = PAL_ADJECTIVE[randi() % PAL_ADJECTIVE.size()] + PAL_OBJECT[randi() % PAL_OBJECT.size()] + PAL_NAME[randi() % PAL_NAME.size()]
#	var elven_city = ELF_NAME1[randi() % ELF_NAME1.size()] + ELF_NAME2[randi() % ELF_NAME2.size()]
#	# Print names
#	print("The evil mage " + evil_mage)
#	print ("The Dwarven " + dwarf_clan_name + " clan")
#	print("A Paladin of " + paladin_order)
#	print("An Elven rogue from " + elven_city)

func save():
	var data = {}
	data.mage = mage
	data.npc_greenskin1 = npc_greenskin1
	data.npc_greenskin2 = npc_greenskin2
	return data

func restore(data):
	mage = data.mage
	npc_greenskin1 = data.npc_greenskin1
	npc_greenskin2 = data.npc_greenskin2

func loadNames(markov, markov_names):
	for name in markov_names:
		var currName = name
		for i in range(currName.length()):
			var currLetter = currName[i].to_lower()
			var letterToAdd;
			if i == (currName.length() - 1):
				letterToAdd = "."
			else:
				letterToAdd = currName[i+1]
			var tempList = []
			if markov.has(currLetter):
				tempList = markov[currLetter]
			tempList.append(letterToAdd)
			markov[currLetter] = tempList

func getName (firstChar, minLength, maxLength):
	var count = 1
	var name = ""
	if firstChar:
		name += firstChar
	else:
		var random_letter = alphabet[GameData.roll(0, alphabet.size()-1)]
		name += random_letter
	while count < maxLength:
		var new_last = name.length()-1
		var nextLetter = getNextLetter(name[new_last])
		if str(nextLetter) == ".":
			if count > minLength:
				return name
		else:
			name += str(nextLetter)
			count+=1
	return name

func getNextLetter(letter):
	var thisList = markov[letter]
	return thisList[GameData.roll(0, thisList.size()-1)]

