extends Control

onready var versionlabel = get_node('Menu/Version')
onready var newgame_icon = get_node('Menu/CentreRow/Buttons/HBoxContainer/ng_icon')
onready var continue_icon  = get_node('Menu/CentreRow/Buttons/HBoxContainer 2/cn_icon')
onready var quit_icon  = get_node('Menu/CentreRow/Buttons/HBoxContainer 3/qt_icon')

func _ready():
	# hide hover icons
	newgame_icon.hide()
	continue_icon.hide()
	quit_icon.hide()
	randomize()
	versionlabel.set_text(GameData.version)
	# check for save file
	var file = File.new()
	var save_exists = file.file_exists(GameData.SAVEGAME_PATH)
	var button = get_node("Menu/CentreRow/Buttons/HBoxContainer 2/Continue")
	button.set_disabled(!save_exists)
	if !save_exists:
		get_node('Menu/CentreRow/Buttons/HBoxContainer 2/Continue/Label').add_color_override("font_color", Color(0, 0.55, 0.55, 1))

# new game
func _on_NewGame_pressed():
	GameData.player_moves = 0
	GameData.load_continue = "load"
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')

# continue saved game
func _on_Continue_pressed():
	GameData.load_continue = "continue"
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')

# quit game
func _on_Quit_pressed():
	get_tree().quit()

# menu hover effect
func _on_NewGame_mouse_enter():
	newgame_icon.show()

func _on_NewGame_mouse_exit():
	newgame_icon.hide()

func _on_Continue_mouse_enter():
	continue_icon.show()

func _on_Continue_mouse_exit():
	continue_icon.hide()

func _on_Quit_mouse_enter():
	quit_icon.show()

func _on_Quit_mouse_exit():
	quit_icon.hide()
