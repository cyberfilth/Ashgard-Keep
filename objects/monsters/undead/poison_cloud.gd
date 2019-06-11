extends Node2D

onready var cloud = get_node('green_cloud')

func _ready():
	cloud.set_emitting(true)