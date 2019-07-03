extends Node

const version = "Version 0.5"

const SAVEGAME_PATH = 'user://game.sav'
const ENCRYPTION_PASSWORD = "password"

const COLOR_LIGHT_BLUE = '#91B4C1' # Default broadcast message
const COLOR_RED = '#d04648' # Player damage taken
const COLOR_BLUE = '#6C73AA' # looks confused || Slot button pressed issue, bluer blue
const COLOR_TEAL = '#5C899E' # is slain
const COLOR_GREEN = '#65f23e' # Uses health potion
const COLOR_YELLOW = '#dad45e' # Item / object has been found
const COLOR_POISON_GREEN = '#48a000' # Poisoned
const COLOR_NECROTIC_PURPLE = '#9932cc' # Necromancy magic

const LAYER_DECAL = 0
const LAYER_ITEM = 1
const LAYER_ACTOR = 2
const LAYER_FX = 3

var player_moves
var restore_game = false
var player_data = {}

# Randomly generated dungeon theme number
var dungeonRNG

# Player sight radius
var TORCH_RADIUS = 5
# 'Hunger clock'
var getting_dimmer = false
var torch_height
var torch_timer
var colr
var colg
var colb

# Dungeon map parameters
var MAP_SIZE = Vector2(70, 70) # Changed from 80, 80
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
var load_continue = "load"

# RIP - You were killed by
var killer = "An unknown enemy"

# Broadcast status messages
func broadcast(message, color=COLOR_LIGHT_BLUE):
	if game:
		if game.messagebox:
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
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
	#dungeonRNG = roll(0,3)
	dungeonRNG = 0 # set number here to test a new dungeon