# web_trap_AI

extends Node

onready var owner = get_parent()
var detection_timer = 5 # time between noticing a web and it appearing
var warning_issued = false # Show warning message only once
var triggered = false # trap has been triggered
var reset_timer = 8 # Resets trap after it's been triggered

func _ready():
	owner.ai = self
	get_parent().get_node('Sprite').hide()

func take_turn():
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	# If in range of the player and the trap is not triggered
	if triggered == false && distance <= GameData.player_radius:
		if distance == GameData.player_radius:
			GameData.broadcast("...You sense something strange...", GameData.COLOUR_YELLOW)
			detection_timer -=1
		elif (distance < GameData.player_radius) && (detection_timer == 2):
			if warning_issued == false:
				GameData.broadcast("A web brushes your face...", GameData.COLOUR_YELLOW)
				warning_issued = true
				detection_timer -= 1
		elif (distance < GameData.player_radius) && (detection_timer >= 1):
				detection_timer -= 1
		else: # trap become visible
			triggered = true
			get_parent().get_node('Sprite').show()
			if distance < 1 && reset_timer >= 8:
				GameData.broadcast("You are trapped in a spider web.", GameData.COLOUR_YELLOW)
				GameData.player.fighter.stuck(6)
				reset_timer = 0
			else:
				GameData.broadcast("You discover a giant spider web!", GameData.COLOUR_YELLOW)
	elif triggered == true && distance < 1 && reset_timer >=8:
		GameData.broadcast("You are trapped in a spider web.", GameData.COLOUR_YELLOW)
		GameData.player.fighter.stuck(6)
		reset_timer = 0
	else:
		reset_timer += 1