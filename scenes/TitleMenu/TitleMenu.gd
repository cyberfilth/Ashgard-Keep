extends Control


func _ready():
	pass


func _on_NewGame_pressed():
	get_tree().change_scene('res://scenes/Game/Game.tscn')