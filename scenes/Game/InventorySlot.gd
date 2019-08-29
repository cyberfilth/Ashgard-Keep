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

func show_equipped_weapon():
	get_node('EQ_weapon').show()

func extinguish_torch():
	get_node('Torch_unlit').show()

func light_torch():
	get_node('Torch_unlit').hide()

func show_unequipped_weapon():
	get_node('EQ_weapon').hide()

func show_equipped_armour():
	get_node('EQ_armour').show()

func show_unequipped_armour():
	get_node('EQ_armour').hide()

func _ready():
	connect("mouse_enter", get_parent(), "_on_slot_mouse_enter", [self])
	connect("mouse_exit", get_parent(), "_on_slot_mouse_exit")
	connect("pressed", get_parent(), "_on_InventorySlot_pressed", [self])
	connect("pressed", get_parent(), "_on_slot_item_used", [self])