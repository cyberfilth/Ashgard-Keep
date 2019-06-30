extends PopupPanel

onready var levellabel = get_parent().get_node('LevelUp/VBoxContainer/LevelUp')
onready var flavourlabel = get_parent().get_node('LevelUp/VBoxContainer/FlavourText')

func _ready():
	pass

func start(level):
	levellabel.set_text("You have advanced to " + str(level))
	flavourlabel.set_text("Your experiences in the Keep have sharpened your skills.\nYou can choose to increase one of the following abilities.")
# offer choice of 20% HP increase or add level to ATT or DEF
# increase HP before exiting