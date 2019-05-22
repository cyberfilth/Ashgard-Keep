extends Node

# Darkness families
var DARKNESS1 = Color( 0.27, 0.27, 0.27, 1 )
var DARKNESS2 = Color( 0.75, 0.59, 0.46, 1 )
var DARKNESS3 = Color( 0.25, 0.32, 0.34, 1 )

# Dungeon tile families
var FAMILY1 = [FLOOR_SANDSTONE, WALL_SANDSTONE]
var FAMILY2 = [FLOOR_BRICK_DARK, WALL_BRICK_DARK]
var FAMILY3 = [FLOOR_COBBLE_BLOOD, WALL_STONE_GREY]

# Dungeon tiles
const WALL_SANDSTONE = [0, 9]
const WALL_BRICK_DARK = [20, 26]
const WALL_STONE_GREY = [34, 37]

const FLOOR_SANDSTONE = [10, 19]
const FLOOR_BRICK_DARK = [27, 33]
const FLOOR_COBBLE_BLOOD = [38, 49]

var themes = [
{ # 1 - Sandstone
tileset = FAMILY1,
darkness = DARKNESS1,
minion = 'monsters/2/rat',
undead = 'monsters/1/zombie'
},
{ # 2 - Brick Dark
tileset = FAMILY2,
darkness = DARKNESS2,
minion = 'monsters/2/rat',
undead = 'monsters/1/zombie'
},
{ # 3 - Bloody Cobbles
tileset = FAMILY3,
darkness = DARKNESS3,
minion = 'monsters/2/rat',
undead = 'monsters/1/zombie'
}
]
