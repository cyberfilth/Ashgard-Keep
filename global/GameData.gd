extends Node

const version = "Version 0.8.6"

const SAVEGAME_PATH = 'user://game.sav'
const ENCRYPTION_PASSWORD = "password"

const COLOUR_LIGHT_BLUE = '#91B4C1' # Default broadcast message
const COLOUR_RED = '#d04648' # Player damage taken
const COLOUR_BLUE = '#6C73AA' # looks confused || Slot button pressed issue, bluer blue
const COLOUR_TEAL = '#5C899E' # is slain
const COLOUR_GREEN = '#65f23e' # Uses potion
const COLOUR_YELLOW = '#dad45e' # Item / object has been found
const COLOUR_POISON_GREEN = '#48a000' # Poisoned
const COLOUR_NECROTIC_PURPLE = '#9932cc' # Necromancy magic
const COLOUR_ORANGE = '#e1bb37' # Torch messages
const COLOUR_SLATE_GREY = '#708090' # Paralysed colour

const LAYER_DECAL = 0
const LAYER_ITEM = 1
const LAYER_ACTOR = 2
const LAYER_FX = 3

var player_moves
var player_data = {}

# Randomly generated enemy theme number
var enemyRNG

# Area around the player
var player_radius = 5
# Keep original value when using stealth potion
var original_player_radius
# Distance the player can see
var player_view
# 'Hunger clock'
var getting_dimmer # 0 - off, 1 - dimmer, 2 - dark
var torch_timer
var light_circle
var colr
var colg
var colb

# Dungeon map parameters
var MAP_SIZE = Vector2(60, 60) # Changed from 70, 70
var MAX_ROOMS = 60
var ROOM_MIN_SIZE = 5
var ROOM_MAX_SIZE = 13

# Game variables
var game
var player
var map
var inventory
var inventory_menu
var levelup_menu
var load_continue_newlvl = "load" # Variable passed to TitleMenu
var keeplvl # current floor of the Keep
var dungeon_theme_array = [] # Random array of dungeon themes
var temp_array2 = [] # Temp array for dungeon theme sorting
var use_item = "cannot be used"
var in_use = false # Whether an item is currently being used, i.e. A spell waiting for a target to be selected
# stored in case a weapon breaks
var weapon_in_use
var weapon_slot
var weapon_name
var weapon_type

# RIP - You were killed by
var killer = "An unknown enemy"

# List of enemies killed
var death_list = []

# message log icons
var torch_icon = load('res://graphics/gui/ml_torch.png')

# Broadcast status messages
func broadcast(message, color=COLOUR_LIGHT_BLUE):
	if game:
		if game.messagebox:
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
			game.messagebox.newline()

# Broadcast messages about torch with icon
func broadcast_torch(message, color=COLOUR_ORANGE):
	if game:
		if game.messagebox:
			game.messagebox.add_image(torch_icon)
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
			game.messagebox.add_image(torch_icon)
			game.messagebox.newline()

# Clear status messages
func clear_messages():
	game.messagebox.clear()

# Random number generator
func roll(l,h):
	return int(round(rand_range(l,h)))

# Game calendar
const TROLL_DAY = {1:"Onesday", 2:"Twosday", 3:"Frogday", 4:"Hawksday", 5:"Feastday", 6:"Marketday", 0:"Fastday"}
const TROLL_MONTH = {1:"Mistmon", 2:"Brittleice", 3:"Windmon", 4:"Gunther", 5:"Sweetbriar", 6:"Greenling", 7:"Frogsong", 8:"Sunmon", 9:"Southflight", 10:"Harvestmoon", 11:"Ghostmoon", 12:"Stormlight"}

# Shuffle the array of dungeon themes
func set_dungeon_theme():
	temp_array2.clear()
	dungeon_theme_array.clear()
	var temp_list = range(DungeonThemes.original_dungeon_themes.size())
	temp_array2 = [] + DungeonThemes.original_dungeon_themes
	for i in range(temp_array2.size()):
		var x = randi()%temp_list.size()
		dungeon_theme_array.append(temp_array2[x])
		temp_list.remove(x)
		temp_array2.remove(x)
	return

func set_enemy_theme():
	enemyRNG = roll(0,1)
	#enemyRNG = 1 # set number here to test enemies

 #############################################
 #  Sve player stats when entering new level #
 #############################################
var lvlname
var lvlcharacter_level
var lvlattack
var lvldefence
var lvlmaxhp
var lvlhp
var lvlxp
var lvlweapon_equipped
var lvlarmour_equipped
var player_inventory = []