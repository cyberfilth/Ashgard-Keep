extends Node2D

onready var flames = get_node('flame_particles')

func _ready():
	flames.set_emitting(true)

