extends Node

const version = "Version 0.4"

const SAVEGAME_PATH = 'user://game.sav'
const ENCRYPTION_PASSWORD = "password"

const COLOR_WHITE = '#91B4C1' # Default broadcast message
const COLOR_DARK_GREY = '#bb3f40' # Monster damage taken
const COLOR_RED = '#d04648' # Player damage taken
const COLOR_BROWN = '#6C73AA' # looks confused || Slot button pressed issue
const COLOR_DARK_GREEN = '#5C899E' # is slain
const COLOR_GREEN = '#64B187' # Uses health potion
const COLOR_YELLOW = '#dad45e' # Item / object has been found

const LAYER_DECAL = 0
const LAYER_ITEM = 1
const LAYER_ACTOR = 2
const LAYER_FX = 3

var restore_game = false

var player_data = {}

## replaced with randomly generated theme number
var dungeonRNG

var TORCH_RADIUS = 5

var MAP_SIZE = Vector2(80, 80) # Changed from 100, 80
var MAX_ROOMS = 60
var ROOM_MIN_SIZE = 5
var ROOM_MAX_SIZE = 13


var game
var player
var map
var inventory
var inventory_menu
var load_continue = "load"


func broadcast(message, color=COLOR_WHITE):
	if game:
		if game.messagebox:
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
			game.messagebox.newline()

func roll(l,h):
	return int(round(rand_range(l,h)))

func set_dungeon_theme():
	dungeonRNG = roll(0,2)
	#dungeonRNG = 2 # set number here to test a new dungeon
