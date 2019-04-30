extends Node

# Darkness families
var SANDSTONE_DARKNESS = Color( 0.27, 0.27, 0.27, 1 )
var BRICK_DARK_DARKNESS = Color( 0.75, 0.59, 0.46, 1 )

# Dungeon tile families
var FAMILY_SANDSTONE = [FLOOR_SANDSTONE, WALL_SANDSTONE]
var FAMILY_BRICK_DARK = [FLOOR_BRICK_DARK, WALL_BRICK_DARK]

# Dungeon tiles
const WALL_SANDSTONE = [0,9]
const WALL_BRICK_DARK = [20,26]

const FLOOR_SANDSTONE = [10,19]
const FLOOR_BRICK_DARK = [27,33]