extends Node2D

onready var cloud = get_node('pixie_sparkles')

func _ready():
	cloud.set_emitting(true)
# Timer
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	queue_free()