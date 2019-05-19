# Attached Player.Camera (Player.tscn)
extends Camera2D

var velocity = -50
var timer = 0
var max_mag
var mag

func _ready():
	set_process(true)

func _process(delta):
	if timer > 0:
		set_offset(Vector2( rand_range(-1.0, 1.0) * mag,    \
							rand_range(-1.0, 1.0) * mag     ))
		timer -= delta
		mag = timer * max_mag
	else:
		set_offset(Vector2(0, 0))

# shake the camera for 'duration' amount of time, with specified 'magnitude'
# currently being tested in world.gd
func shake(duration, magnitude):
	max_mag = magnitude
	timer = duration
	mag = timer * magnitude