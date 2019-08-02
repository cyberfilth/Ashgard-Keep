extends Light2D


func dim_light():
	var darkness_theme = GameData.dungeon_theme_array[GameData.keeplvl-1]
	if darkness_theme == 0:
		GameData.colr = 0.27
		GameData.colg = 0.27
		GameData.colb = 0.27
	if darkness_theme == 1:
		GameData.colr = 0.75
		GameData.colg = 0.59
		GameData.colb = 0.46
	if darkness_theme == 2 || darkness_theme == 3 || darkness_theme == 4:
		GameData.colr = 0.25
		GameData.colg = 0.32
		GameData.colb = 0.34
	darker()

func darker():
	GameData.colr = GameData.colr - 0.05
	GameData.colg = GameData.colg - 0.05
	GameData.colb = GameData.colb - 0.05
	get_node('../../Darkness').set_color(Color(GameData.colr, GameData.colg, GameData.colb, 1))
	self.set_texture_scale(self.get_texture_scale()-2)
	GameData.light_circle = self.get_texture_scale()

func total_darkness():
	GameData.colr = 0
	GameData.colg = 0
	GameData.colb = 0
	get_node('../../Darkness').set_color(Color(GameData.colr, GameData.colg, GameData.colb, 1))
	self.set_texture_scale(2.0)
	get_node('/root/Game/frame/right/Activity/box/Inventory/InventorySlot').extinguish_torch()

func restore_game_darkness():
	get_node('/root/Game/frame/right/Activity/box/Inventory/InventorySlot').light_torch()
	get_node('../../Darkness').set_color(Color(GameData.colr,GameData.colg,GameData.colb))
	self.set_texture_scale(GameData.light_circle)