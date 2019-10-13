# yellow_fungus_AI

extends Node

onready var parent = get_parent()

func _ready():
	parent.ai = self

func take_turn():
	pass
