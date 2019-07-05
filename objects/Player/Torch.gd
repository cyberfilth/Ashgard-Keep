extends Light2D

func _ready():
	pass

func dim_light():
	if GameData.dungeonRNG == 0:
		GameData.colr = 0.27
		GameData.colg = 0.27
		GameData.colb = 0.27
	if GameData.dungeonRNG == 1:
		GameData.colr = 0.75
		GameData.colg = 0.59
		GameData.colb = 0.46
	if GameData.dungeonRNG == 2:
		GameData.colr = 0.25
		GameData.colg = 0.32
		GameData.colb = 0.34
	if GameData.dungeonRNG == 3:
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

func total_darkness():
	GameData.colr = 0
	GameData.colg = 0
	GameData.colb = 0
	get_node('../../Darkness').set_color(Color(GameData.colr, GameData.colg, GameData.colb, 1))
	self.set_texture_scale(2.0)

func restore_game_darkness():
	get_node('../../Darkness').set_color(DungeonThemes.themes[GameData.dungeonRNG])
	self.set_height(64.9)
	self.set_texture_scale(13.5)