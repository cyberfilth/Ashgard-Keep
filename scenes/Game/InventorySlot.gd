extends Button

var contents = []

func add_contents(what):
	contents.append(what)
	what.item.inventory_slot = self
	update_slot()

func remove_contents(what):
	contents.remove(contents.find(what))
	what.item.inventory_slot = null
	update_slot()


func update_slot():
	if !contents.empty():
		get_node('Icon').set_texture(contents[0].get_icon())
		get_node('Brand').set_texture(contents[0].get_brand())
		set_disabled(false)
	else:
		get_node('Icon').set_texture(null)
		get_node('Brand').set_texture(null)
		set_disabled(true)
	var count = contents.size()
	var txt = str(count) if count > 1 else ''
	get_node('Count').set_text(txt)



func _ready():
	connect("mouse_enter", get_parent(), "_on_slot_mouse_enter", [self])
	connect("mouse_exit", get_parent(), "_on_slot_mouse_exit")


func _on_InventorySlot_pressed():
	var obj = contents[0]
	contents.remove(0)
	obj.item.use()
	update_slot()
