extends Control

onready var RIPmessage = get_node('Menu/CentreRow/message/RichTextLabel')
var what_killed_you
var death_description

func _ready():
	# Delete saved game
	var dir = Directory.new()
	if dir.file_exists(GameData.SAVEGAME_PATH):
		dir.remove(GameData.SAVEGAME_PATH)
	# Get list if all enemies killed
	var list_string = ""
	for i in range(0,GameData.death_list.size()):
		GameData.death_list.sort()
		if GameData.death_list.count(GameData.death_list[i]) > 1:
			if GameData.death_list[i] != GameData.death_list[i-1]:
				list_string +=GameData.death_list[i]+" x "+str(GameData.death_list.count(GameData.death_list[i]))+"\n"
		else:
			list_string+=GameData.death_list[i]+"\n"
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
	# and the method of your death more descriptive
	killer_description(GameData.killer)
	type_of_death()
	# Print death message
	RIPmessage.set_text("You "+death_description+" by " + what_killed_you+\
	"\nOn the "+keep_level+" floor of the Keep after "+str(GameData.player_moves)+ " moves.\n\n"\
	+"You defeated; \n"+list_string)
	
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
	elif killer == "Hell Hound":
		what_killed_you = "a ferocious Hell Hound."
	elif killer == "A black shape":
		what_killed_you = "an unseen black shape."
	elif killer == "Goblin":
		what_killed_you = "a Goblin."
	elif killer == "Goblin Witch doctor":
		what_killed_you = "a malevolent Goblin Witch doctor."
	elif killer == "Orc Warrior":
		what_killed_you = "an Orc Warrior."
	elif killer == "Ratling":
		what_killed_you = "a cowardly Ratling."
	elif killer == "Mushroom Person":
		what_killed_you = "a twisted, deformed Mushroom person."
	else:
		what_killed_you = GameData.killer

func type_of_death():
	if GameData.player_moves <= 150:
		if GameData.player_moves < 100:
			death_description = "died before your quest had even begun, killed"
		else:
			death_description = "were killed embarrassingly early"
	elif what_killed_you == "Fire":
		death_description = "were burned to death"
	elif what_killed_you == "Bat":
		death_description = "were nibbled to death"
	elif what_killed_you == "Hell Hound":
		death_description = "were eaten"
	elif what_killed_you == "Rock":
		death_description = "were crushed"
	else:
		death_description = "were killed"

func _on_Button_pressed():
	get_tree().change_scene('res://scenes/TitleMenu/TitleMenu.tscn')