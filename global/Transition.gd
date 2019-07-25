extends CanvasLayer

# Scene to transition to
var path = ""

func change_scene():
	if path != "":
		get_tree().change_scene(path)

func fade_to(scn_path):
	self.path = scn_path # store the scene path
	get_node("Centered/AnimationPlayer").play("fade") # play the transition animation