extends Control

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_NewGame_pressed():
	get_tree().change_scene('res://scenes/Game/Game.tscn')
