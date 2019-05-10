extends Control

onready var versionlabel = get_node('Menu/Version')

func _ready():
	randomize()
	versionlabel.set_text(GameData.version)
	


func _on_NewGame_pressed():
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')

func _on_Continue_pressed():
	GameData.restore_game = true
	get_tree().change_scene('res://scenes/Game/Game.tscn')


func _on_Quit_pressed():
	get_tree().quit()
