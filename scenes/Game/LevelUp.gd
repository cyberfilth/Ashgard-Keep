extends PopupPanel

onready var levellabel = get_parent().get_node('LevelUp/VBoxContainer/LevelUp')
onready var flavourlabel = get_parent().get_node('LevelUp/VBoxContainer/FlavourText')
onready var increaseATT_label = get_parent().get_node('LevelUp/VBoxContainer/IncreaseATT')
onready var increaseDEF_label = get_parent().get_node('LevelUp/VBoxContainer/IncreaseDEF')
onready var increaseATTDEF_label = get_parent().get_node('LevelUp/VBoxContainer/IncreaseATTDEF')

func _ready():
	pass

func start(level):
	levellabel.set_text("You have advanced to " + str(level))
	flavourlabel.set_text("Your experiences in the Keep have sharpened your skills.\nYou can choose to increase one of the following abilities.")
	increaseATT_label.set_text("Increase Attack by "+str(level))
	increaseDEF_label.set_text("Increase Defence by "+str(level))
	increaseATTDEF_label.set_text("Increase both Attack and Defence by "+str(floor(level/2)))