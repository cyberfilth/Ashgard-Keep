extends Node

onready var owner = get_parent()

export(bool) var bleeds = true

var hp = 5 setget _set_hp

var power = 1

func fight(who):
	if who.fighter:
		who.fighter.take_damage(self,self.power)

func take_damage(from,amount):
	self.hp -= amount

func die():
	if self.bleeds:
		bleed()
	owner.kill()

func bleed():
	var blood = load('res://graphics/misc/blood_red'+str(randi()%5)+'.png')
	var sprite = Sprite.new()
	sprite.set_centered(false)
	sprite.set_texture(blood)
	RPG.map.add_child(sprite)
	sprite.set_pos(RPG.map.map_to_world(owner.get_map_pos()))

func _ready():
	owner.fighter = self
	owner.add_to_group('actors')


func _set_hp(what):
	hp = what
	if hp <= 0:
		die()



