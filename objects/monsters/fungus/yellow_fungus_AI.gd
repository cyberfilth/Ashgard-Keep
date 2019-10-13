# yellow_fungus_AI

extends Node

onready var owner = get_parent()

func _ready():
	owner.ai = self

func take_turn():
	pass
