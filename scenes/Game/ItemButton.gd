extends Button

var owner = null setget _set_owner



func _set_owner(what):
	owner = what
	set_text(owner.get_display_name())
	set_button_icon(owner.get_icon())
	get_node('Brand').set_texture(owner.get_brand())
