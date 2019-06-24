# necro_energy.gd

extends Node2D

var bolt_rotation

func _ready():
	pass

func init(necromancer):
	var necromancer_position = get_node('start')
	var target_position = get_node('end')
	var bolt = get_node('bolt')
	var targetpos = GameData.player.get_pos()
	
	necromancer_position.set_pos(necromancer)
	bolt.set_pos(necromancer)
	target_position.set_pos(targetpos)
	var bolt_height = pow((target_position.get_pos().y - necromancer_position.get_pos().y), 2)
	var bolt_width = pow((target_position.get_pos().x - necromancer_position.get_pos().x), 2)
	var bolt_length = sqrt(bolt_height + bolt_width)
	bolt.set_region_rect(Rect2(0, 0, bolt_length, 24))
	
	# For bolt rotation
	var y_result = -(target_position.get_pos().y - necromancer_position.get_pos().y)
	var x_result = target_position.get_pos().x - necromancer_position.get_pos().x
	bolt_rotation = atan(y_result / x_result)
	if target_position.get_pos().x < necromancer_position.get_pos().x:
		bolt.set_offset(Vector2(-6, -24))
		bolt_rotation = bolt_rotation + PI
	elif target_position.get_pos().x == necromancer_position.get_pos().x:
		if target_position.get_pos().y > necromancer_position.get_pos().y:
			bolt.set_offset(Vector2(0, -24))
		else:
			bolt.set_offset(Vector2(0, 0))
	
	bolt.rotate(bolt_rotation)
	var t = Timer.new()
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	bolt.hide()
