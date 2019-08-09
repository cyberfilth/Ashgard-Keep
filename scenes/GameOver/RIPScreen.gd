extends Control

onready var RIPmessage = get_node('Menu/CentreRow/message/RichTextLabel')

func _ready():
	# Delete saved game
	var dir = Directory.new()
	if dir.file_exists(GameData.SAVEGAME_PATH):
		dir.remove(GameData.SAVEGAME_PATH)
	# Print death message
	RIPmessage.set_text("You were killed by a " + GameData.killer+\
	"\nOn the first floor of the Keep after "+str(GameData.player_moves)+ " moves.")
	# Unpause process
	get_tree().set_pause(false)

func _on_Button_pressed():
	get_tree().change_scene('res://scenes/TitleMenu/TitleMenu.tscn')
