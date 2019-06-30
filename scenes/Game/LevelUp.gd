extends PopupPanel

onready var levellabel = get_parent().get_node('LevelUp/VBoxContainer/Label')

func _ready():
	pass

func start(level):
	levellabel.set_text("You have advanced to " + str(level))