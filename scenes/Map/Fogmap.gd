extends TileMap

onready var map = get_parent()
#var map = null

func fill():
	for x in range(map.size()):
		for y in range(map[x].size()):
			#print("Filling fog for cell: " + str(x) + " " + str(y))
			#set_cell(x,y, map.data[x][y])
			set_cell(x,y,0)

#-------------------
# lightmap
func fill_cells(cells):
	for cell in cells:
		set_cell(cell[0],cell[1], map.data.map[cell[0]][cell[1]])

func reveal_all():
	for x in range(map.data.map.size()):
		for y in range(map.data.map[x].size()):
			#print("Filling fog for cell: " + str(x) + " " + str(y))
			set_cell(x,y, -1)


func reveal(cells):
	for cell in cells:
		#print("Revealing cell " + str(cell))
		#print(str(get_cell(cell[0], cell[1])))
		#if get_cell(cell[0], cell[1]) != -1:
		if get_cellv(cell) != -1:
			set_cellv(cell,-1)
		#set_cell(cell[0], cell[1], -1)
		#print("Revealed cell " + str(cell))

# for game load
func reveal_from_data(data):
	#print("Revealing from data..")
	var cells = []
	for x in range(data.size()-1):
		for y in range(data[x].size()-1):
			if data[x][y] == -1:
				cells.append(Vector2(x,y))
	reveal(cells)

func get_fog_data(size_x, size_y):
	var data = []
	#var size = RPG.MAP_SIZE
	for x in range(size_x):
		var col = []
		for y in range(size_y):
			col.append(get_cell(x,y))
		data.append(col)
	return data


func _ready():
	# if we're not loading:
	#if not RPG.restore_game:
		# we have to defer since otherwise we don't have access to map data
	call_deferred("fill") #fill()
	