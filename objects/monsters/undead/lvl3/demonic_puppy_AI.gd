# demonic_puppy_AI

extends Node

onready var parent = get_parent()

func _ready():
	parent.ai = self

func take_turn():
	if parent.fighter.has_status_effect('confused'):
		wander()
	var target = GameData.player
	var distance = parent.distance_to(target.get_map_position())
	if parent.fighter.hp <= 5 && distance < 2:
		transform_to_hound()
	if distance <= (GameData.player_radius - 2):
		if distance <= 1:
			parent.fighter.fight(target)
		else:
			parent.step_to(target.get_map_position())
	else:
		wander()

func transform_to_hound():
	var fiery_birth = load("res://graphics/particles/Flames.tscn")
	var scene_instance = fiery_birth.instance()
	scene_instance.set_name("fiery_birth")
	GameData.map.add_child(scene_instance)
	scene_instance.set_position(GameData.map.map_to_world(parent.get_map_position()))

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	parent.step(dir)
