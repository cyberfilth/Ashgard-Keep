extends Node

var themes = [
{ # 1 - Sandstone
tileset = FAMILY1,
darkness = DARKNESS1
},
{ # 2 - Brick Dark
tileset = FAMILY2,
darkness = DARKNESS2
}
]

# Darkness families
var DARKNESS1 = Color( 0.27, 0.27, 0.27, 1 )
var DARKNESS2 = Color( 0.75, 0.59, 0.46, 1 )

# Dungeon tile families
var FAMILY1 = [FLOOR_SANDSTONE, WALL_SANDSTONE]
var FAMILY2 = [FLOOR_BRICK_DARK, WALL_BRICK_DARK]

# Dungeon tiles
const WALL_SANDSTONE = [0,9]
const WALL_BRICK_DARK = [20,26]

const FLOOR_SANDSTONE = [10,19]
const FLOOR_BRICK_DARK = [27,33]