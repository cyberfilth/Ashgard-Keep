extends Node

# This is kept in a separate scene from the Title Menu
# so the randomize function is only called once
func _ready():
	randomize()
	get_tree().change_scene('res://scenes/TitleMenu/TitleMenu.tscn')