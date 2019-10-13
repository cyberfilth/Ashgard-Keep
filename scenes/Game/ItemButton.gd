extends Button

var parent = null setget _set_parent

func _set_parent(what):
	parent = what
	set_text(parent.get_display_name())
	set_button_icon(parent.get_icon())
	get_node('Brand').set_texture(parent.get_brand())
