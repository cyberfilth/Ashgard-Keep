extends Control

onready var versionlabel = get_node('Menu/Version')

func _ready():
	versionlabel.set_text(GameData.version)
	# Timer added to give time for screen to load
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	GameData.restore_game = true
	get_tree().change_scene('res://scenes/Game/Game.tscn')
	get_tree().change_scene('res://scenes/Game/Game.tscn')
