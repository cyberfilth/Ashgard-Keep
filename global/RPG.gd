extends Node

onready var _db = preload( "res://objects/components/Database.tscn" ).instance()

func make_object( path ):
	return _db.spawn( path )

var MAP_SIZE = Vector2(100,80) # originally 120, 80
var MAX_ROOMS = 60
var ROOM_MIN_SIZE = 5
var ROOM_MAX_SIZE = 15

#var player
var map

func roll(l,h):
	return int(round(rand_range(l,h)))