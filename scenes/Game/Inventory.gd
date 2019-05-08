extends GridContainer

onready var objects = get_node('../InventoryObjects')
onready var name_label = get_node('../ItemName')



# Get an array of all inventory Objects
func get_objects():
	return self.objects.get_children()

# Get the first free inventoryslot
func get_free_slot():
	for node in get_children():
		if node.contents.empty():
			return node

# find an inventoryslot which contains an item
func get_matching_slot(item):
	for node in get_children():
		if not node.contents.empty():
			if node.contents[0].name == item.name:
				return node

# add an item to an inventoryslot
func add_to_inventory(item):
	var slot = null
	if item.item && item.item.stackable:
		# find a matching slot
		slot = get_matching_slot(item)
	# find free slot if no matches found
	if !slot: slot = get_free_slot()
	# break if no slots free
	if !slot: return
	
	# remove from world objects group
	if item.is_in_group('objects'):
		item.remove_from_group('objects')
	# add to inventory group
	if !item.is_in_group('inventory'):
		item.add_to_group('inventory')
	
	# shift item parent from Map to InventoryObjects
	if item.get_parent() == GameData.map:
		item.get_parent().remove_child(item)
	objects.add_child(item)
	
	# assign the item to the slot
	slot.add_contents(item)
	return OK


func remove_from_inventory(slot, item):
	slot.remove_contents(item)
	item.remove_from_group('inventory')
	item.add_to_group('objects')
	item.get_parent().remove_child(item)
	GameData.map.add_child(item)
	item.set_map_pos(GameData.player.get_map_pos())

func call_drop_menu():
	var header = "Choose item(s) to Drop..."
	var footer = "ENTER to confirm, ESC or RMB to cancel"
	GameData.inventory_menu.start(true, header, footer)

func call_throw_menu():
	var header = "Choose an item to Throw..."
	var footer = "ENTER to confirm, ESC or RMB to cancel"
	GameData.inventory_menu.start(false, header, footer)




func _ready():
	GameData.inventory = self


func _on_slot_mouse_enter(slot):
	var name = '' if slot.contents.empty() else slot.contents[0].get_display_name()
	var count = slot.contents.size()
	var nt = '' if count < 2 else str(count)+'x '
	name_label.set_text(nt + name)

func _on_slot_mouse_exit():
	name_label.set_text('')


func _on_slot_button_pressed(slot):
	assert !slot.contents.empty()
	var obj = slot.contents[0]
	var result = yield(obj.item, 'used')
	if result == "OK":
		if not obj.item.indestructible:
			slot.remove_contents(obj)
			obj.kill()
		GameData.player.emit_signal('object_acted')
	else:
		GameData.broadcast(result, GameData.COLOR_BROWN)


func _on_slot_item_used(slot):
	assert !slot.contents.empty()
	slot.contents[0].item.use()


func _on_Drop_pressed():
	var cont = GameData.player.find_node('Controller')
	cont.Drop()


func _on_Throw_pressed():
	var cont = GameData.player.find_node('Controller')
	cont.Throw()
