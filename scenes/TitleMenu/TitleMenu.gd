extends Control

onready var versionlabel = get_node('Menu/Version')

func _ready():
	randomize()
	versionlabel.set_text(GameData.version)
	# check for save file
	var file = File.new()
	var save_exists = file.file_exists(GameData.SAVEGAME_PATH)
	var button = get_node("Menu/CentreRow/Buttons/Continue")
	button.set_disabled(!save_exists)
	if !save_exists:
		get_node('Menu/CentreRow/Buttons/Continue/Label').add_color_override("font_color", Color(0, 0.55, 0.55, 1))
	


func _on_NewGame_pressed():
	GameData.load_continue = "load"
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')

func _on_Continue_pressed():
	GameData.load_continue = "continue"
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')


func _on_Quit_pressed():
	get_tree().quit()
