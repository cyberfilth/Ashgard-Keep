extends Node

const version = "Version 0.6.3"

const SAVEGAME_PATH = 'user://game.sav'
const ENCRYPTION_PASSWORD = "password"

const COLOR_LIGHT_BLUE = '#91B4C1' # Default broadcast message
const COLOR_RED = '#d04648' # Player damage taken
const COLOR_BLUE = '#6C73AA' # looks confused || Slot button pressed issue, bluer blue
const COLOR_TEAL = '#5C899E' # is slain
const COLOR_GREEN = '#65f23e' # Uses potion
const COLOR_YELLOW = '#dad45e' # Item / object has been found
const COLOR_POISON_GREEN = '#48a000' # Poisoned
const COLOR_NECROTIC_PURPLE = '#9932cc' # Necromancy magic
const COLOUR_ORANGE = '#e1bb37' # Torch messages

const LAYER_DECAL = 0
const LAYER_ITEM = 1
const LAYER_ACTOR = 2
const LAYER_FX = 3

var player_moves
var player_data = {}

# Randomly generated dungeon theme number
var dungeonRNG
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
var load_continue_newlvl = "load"
var keeplvl

# RIP - You were killed by
var killer = "An unknown enemy"

# message log icons
var torch_icon = load('res://graphics/gui/ml_torch.png')

# Broadcast status messages
func broadcast(message, color=COLOR_LIGHT_BLUE):
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

func set_dungeon_theme():
	dungeonRNG = roll(0,3)
	#dungeonRNG = 0 # set number here to test a new dungeon

func set_enemy_theme():
	#enemyRNG = roll(0,3)
	enemyRNG = 0 # set number here to test enemies

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