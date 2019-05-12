extends Control

onready var versionlabel = get_node('Menu/Version')
onready var messagelabel = get_node('Menu/CentreRow/message/LoadContinue')
onready var loadingimage = get_node('Menu/CentreRow/CenterContainer/Logo')

func _ready():
	versionlabel.set_text(GameData.version)
	var artwork = load('res://graphics/gui/loading'+str(randi()%3)+'.png')
	loadingimage.set_texture(artwork)
	if GameData.load_continue == "continue":
		messagelabel.set_text("Restoring game...")
	else:
		messagelabel.set_text("Loading...")
	# Timer added to give time for screen to load
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	if GameData.load_continue == "continue":
			GameData.restore_game = true
	get_tree().change_scene('res://scenes/Game/Game.tscn')
