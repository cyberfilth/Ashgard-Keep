# yellow_fungus_AI

extends Node

onready var object_owner = get_parent()

func _ready():
	object_owner.ai = self

func take_turn():
	pass
