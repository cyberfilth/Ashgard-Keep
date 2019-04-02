extends Node

var datamap = []
var start_pos = Vector2()

# Build a new datamap (fill with walls)
func build_datamap():
	var size = RPG.MAP_SIZE
	
	for x in range(size.x):
		var row = []
		for y in range(size.y):
			row.append(1)
		datamap.append(row)

# Set data to a cell in the datamap
func set_cell_data(cell, data):
	datamap[cell.x][cell.y] = data

# find the center cell of a given rectangle
func center(rect):
	var x = int(rect.size.x / 2)
	var y = int(rect.size.y / 2)
	return Vector2(rect.pos.x+x, rect.pos.y+y)

# Fill a rectangle of the map with floor cells
# leaving a 1-tile border along edges
func carve_room(rect):
	for x in range(rect.size.x-2):
		for y in range(rect.size.y-2):
			set_cell_data(Vector2(rect.pos.x+x+1, rect.pos.y+y+1), 0)

# Fill a horizontal strip of cells at row Y from X1 to X2
func carve_h_hall(x1,x2,y):
	for x in range( min( x1, x2 ),max( x1,x2 ) + 1 ):
		set_cell_data( Vector2(x, y), 0 )

# Fill a vertical strip of cells at column X from Y1 to Y2
func carve_v_hall( y1, y2, x):
	for y in range( min( y1, y2 ),max( y1, y2 ) + 1 ):
		set_cell_data( Vector2(x, y), 0 )


func map_to_text():
	var file = File.new()
	file.open('res://map.txt',File.WRITE)
	for row in datamap:
		var t = ''
		for col in row:
			t += str(['_','#'][col])
		file.store_line(t)

	file.close()


func generate():
	build_datamap()
	randomize()
	
	var rooms = []
	var num_rooms = 0
	for r in range(RPG.MAX_ROOMS):
		var w = RPG.roll(RPG.ROOM_MIN_SIZE, RPG.ROOM_MAX_SIZE)
		var h = RPG.roll(RPG.ROOM_MIN_SIZE, RPG.ROOM_MAX_SIZE)
		var x = RPG.roll(0, RPG.MAP_SIZE.x - w-1)
		var y = RPG.roll(0, RPG.MAP_SIZE.y - h-1)
		
		var new_room = Rect2(x,y,w,h)
		var fail = false
		
		for other_room in rooms:
			if other_room.intersects(new_room):
				fail = true
				break
		
		if !fail:
			carve_room(new_room)
			
			var new_center = center(new_room)
			
			if num_rooms == 0:
				start_pos = new_center
			else:
				place_monsters(new_room)
				place_items(new_room)
				var prev_center = center(rooms[num_rooms-1])
				# flip a coin
				if randi()%2 == 0:
					# go horizontal then vertical
					carve_h_hall(prev_center.x, new_center.x, prev_center.y)
					carve_v_hall(prev_center.y, new_center.y, new_center.x)
				else:
					# go vertical then horizontal
					carve_v_hall(prev_center.y, new_center.y, prev_center.x)
					carve_h_hall(prev_center.x, new_center.x, new_center.y)
			
			rooms.append(new_room)
			num_rooms += 1

func place_monsters(room):
	var x = RPG.roll(room.pos.x+1, room.end.x-2)
	var y = RPG.roll(room.pos.y+1, room.end.y-2)
	var pos = Vector2(x,y)
	RPG.map.spawn_object('monsters/Human', pos)

func place_items(room):
	var x = RPG.roll(room.pos.x+1, room.end.x-2)
	var y = RPG.roll(room.pos.y+1, room.end.y-2)
	var pos = Vector2(x,y)
	RPG.map.spawn_object('items/Thing', pos)

