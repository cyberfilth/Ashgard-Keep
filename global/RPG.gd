extends Node

const COLOR_WHITE = '#deeed6'
const COLOR_LIGHT_GREY = '#8595a1'
const COLOR_DARK_GREY = '#4e4a4e'
const COLOR_RED = '#d04648'
const COLOR_BROWN = '#854c30'
const COLOR_DARK_GREEN = '#346524'
const COLOR_GREEN = '#6daa2c'
const COLOR_YELLOW = '#dad45e'

const LAYER_DECAL = 0
const LAYER_ITEM = 1
const LAYER_ACTOR = 2
const LAYER_FX = 3

var TORCH_RADIUS = 6

var MAP_SIZE = Vector2(120,80)
var MAX_ROOMS = 60
var ROOM_MIN_SIZE = 5
var ROOM_MAX_SIZE = 13


var game
var player
var map


func broadcast(message, color=COLOR_WHITE):
	if game:
		if game.messagebox:
			game.messagebox.append_bbcode("[color=" +color+ "]" +message+ "[/color]")
			game.messagebox.newline()

func roll(l,h):
	return int(round(rand_range(l,h)))