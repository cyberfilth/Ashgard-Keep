extends Button

var owner = null setget _set_owner



func _set_owner(what):
	owner = what
	set_text(owner.name)
	set_button_icon(owner.get_icon())
