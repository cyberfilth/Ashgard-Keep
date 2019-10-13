extends Node2D

onready var cloud = get_node('yellow_cloud')

func _ready():
	cloud.set_emitting(true)
