extends Node

# This is kept in a separate scene from the Title Menu
# so the randomize function is only called once.
#
# Seed is printed to the console whilst debugging to
# allow the same game to be run

var game_seed = 0

func _ready():
	randomize()
	if !game_seed:
		game_seed = randi()
	seed(game_seed)
	print("Seed: ", game_seed) # Printed out for testing
	get_tree().change_scene('res://scenes/TitleMenu/TitleMenu.tscn')