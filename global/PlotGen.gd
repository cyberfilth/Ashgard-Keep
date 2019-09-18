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

var mage
var npc_greenskin1
var npc_greenskin2

func generate_plot():
		mage = MAGE_FIRSTNAME[randi() % MAGE_FIRSTNAME.size()] + MAGE_SECONDNAME[randi() % MAGE_SECONDNAME.size()] + TITLE[randi() % TITLE.size()]
		npc_greenskin1 = GOBLIN_NAMES_1[randi() % GOBLIN_NAMES_1.size()]
		npc_greenskin2 = GOBLIN_NAMES_2[randi() % GOBLIN_NAMES_2.size()]
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
