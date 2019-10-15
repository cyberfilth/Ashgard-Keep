extends Button

var object_owner = null setget _set_parent

func _set_parent(what):
	object_owner = what
	set_text(object_owner.get_display_name())
	set_button_icon(object_owner.get_icon())
	get_node('Brand').set_texture(object_owner.get_brand())
