extends Control

onready var RIPmessage = get_node('Menu/CentreRow/message/RichTextLabel')
var what_killed_you
var death_description

func _ready():
	# Delete saved game
	var dir = Directory.new()
	if dir.file_exists(GameData.SAVEGAME_PATH):
		dir.remove(GameData.SAVEGAME_PATH)
	# Get floor level
	var suffix = ""
	var keepfloor = int(GameData.keeplvl)
	if keepfloor == 11 || keepfloor == 12 || keepfloor == 13:
		suffix = "th"
	elif (keepfloor % 10 == 1):
		suffix = "st"
	elif (keepfloor % 10 == 2):
		suffix = "nd"
	elif (keepfloor % 10 == 3):
		suffix = "rd"
	else:
		suffix = "th"
	var keep_level = str(keepfloor)+suffix
	# make the name of the thing that killed you
	# and your method of death more descriptive
	killer_description(GameData.killer)
	type_of_death()
	# Print death message
	RIPmessage.set_text("You "+death_description+" by " + what_killed_you+\
	"\nOn the "+keep_level+" floor of the Keep after "+str(GameData.player_moves)+ " moves.")
	# Unpause process
	get_tree().set_pause(false)

func killer_description(killer):
	if killer == "Poison":
		what_killed_you = "Poison."
	elif killer == "Fire":
		what_killed_you = "Fire."
	elif killer == "Ghoul Rat":
		what_killed_you = "a Ghoul Rat."
	elif killer == "Bat":
		what_killed_you = "a harmless Bat."
	elif killer == "Rat":
		what_killed_you = "a lowly Rat."
	elif killer == "Blood Bat":
		what_killed_you = "a rabid Blood Bat."
	elif killer == "Giant Scorpion":
		what_killed_you = "a hideous Giant Scorpion."
	elif killer == "Zombie":
		what_killed_you = "a foul Zombie."
	elif killer == "Diseased Zombie":
		what_killed_you = "a putrid Diseased Zombie."
	elif killer == "Gnome Necromancer":
		what_killed_you = "a Gnome Necromancer, servant of the dark arts."
	elif killer == "Ghoul":
		what_killed_you = "a slavering Ghoul."
	elif killer == "Hell Puppy":
		what_killed_you = "a cute Hell Puppy."
	elif killer == "Patchwork Golem":
		what_killed_you = "a monstrous Patchwork Golem."
	else:
		what_killed_you = "a "+GameData.killer

func type_of_death():
	if GameData.player_moves <= 150:
		if GameData.player_moves < 100:
			death_description = "died before your quest had even begun, killed"
		else:
			death_description = "were killed embarassingly early"
	elif what_killed_you == "Fire":
		death_description = "were burned to death"
	elif what_killed_you == "Bat":
		death_description = "were nibbled to death"
	else:
		death_description = "were killed"

func _on_Button_pressed():
	get_tree().change_scene('res://scenes/TitleMenu/TitleMenu.tscn')
