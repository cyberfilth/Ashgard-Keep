extends Control

onready var versionlabel = get_node('Menu/Version')

func _ready():
	GameData.restore_game = true
	get_tree().change_scene('res://scenes/Game/Game.tscn')
