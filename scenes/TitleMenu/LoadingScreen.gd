extends Control

onready var versionlabel = get_node('Menu/Version')
onready var messagelabel = get_node('Menu/CentreRow/message/LoadContinue')
onready var loadingimage = get_node('Menu/CentreRow/CenterContainer/Logo')

func _ready():
	versionlabel.set_text(GameData.version)
	var artwork = load('res://graphics/gui/loading'+str(randi()%3)+'.png')
	loadingimage.set_texture(artwork)
	if GameData.load_continue_newlvl == "continue":
		messagelabel.set_text("Restoring game...")
	elif GameData.load_continue_newlvl == "newlvl":
		messagelabel.set_text("Entering the next level...")
		save_player_info_new_level()
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
	get_tree().change_scene('res://scenes/Game/Game.tscn')

func save_player_info_new_level():
	GameData.player_view = 5
	GameData.getting_dimmer = 0
	GameData.torch_timer = 0
	GameData.colr = 0
	GameData.colg = 0
	GameData.colb = 0
	# Save player info
	GameData.lvlname = GameData.player.name