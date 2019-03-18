extends Node

const GREETING = "Hello RPG!"

onready var _db = preload( "res://objects/components/Database.tscn" ).instance()

func make_object( path ):
	return _db.spawn( path )