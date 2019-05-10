extends Control


func _ready():
	randomize()


func _on_NewGame_pressed():
	get_tree().change_scene('res://scenes/Game/Game.tscn')

func _on_Continue_pressed():
	GameData.restore_game = true
	get_tree().change_scene('res://scenes/Game/Game.tscn')


func _on_Quit_pressed():
	get_tree().quit()
