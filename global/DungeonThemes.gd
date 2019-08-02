extends Node

# Dungeon tiles
const WALL_SANDSTONE = [0, 9]
const WALL_BRICK_DARK = [20, 26]
const WALL_STONE_GREY = [34, 37]
const WALL_ASCII = [66, 66]
const WALL_SLIME_STONE = [68, 71]
const WALL_BRICK_BROWN = [76, 83]

const FLOOR_SANDSTONE = [10, 19]
const FLOOR_BRICK_DARK = [27, 33]
const FLOOR_COBBLE_BLOOD = [38, 49]
const FLOOR_GREEN_SLABS = [50, 65]
const FLOOR_ASCII = [67,67]
const FLOOR_BOG_GREEN = [72, 75]
const FLOOR_MARBLE_BROWN = [84, 91]

# Darkness families
var DARKNESS1 = Color( 0.27, 0.27, 0.27, 1 )
var DARKNESS2 = Color( 0.75, 0.59, 0.46, 1 )
var DARKNESS3 = Color( 0.25, 0.32, 0.34, 1 )
var DARKNESS4 = Color( 0.25, 0.32, 0.34, 1 )
var DARKNESS5 = Color( 0.25, 0.32, 0.34, 1 )
var DARKNESS6 = Color( 0.25, 0.32, 0.34, 1 )
var DARKNESS7 = Color( 0.25, 0.32, 0.34, 1 )

# Dungeon tile families
var FAMILY1 = [FLOOR_SANDSTONE, WALL_SANDSTONE]
var FAMILY2 = [FLOOR_BRICK_DARK, WALL_BRICK_DARK]
var FAMILY3 = [FLOOR_COBBLE_BLOOD, WALL_STONE_GREY]
var FAMILY4 = [FLOOR_GREEN_SLABS, WALL_STONE_GREY]
var FAMILY5 = [FLOOR_BOG_GREEN, WALL_SLIME_STONE]
var FAMILY6 = [FLOOR_MARBLE_BROWN, WALL_BRICK_BROWN]
var FAMILY7 = [FLOOR_ASCII, WALL_ASCII]

# All dungeon theme numbers
var original_dungeon_themes = [0,1,2,3,4,5,6]

# Dungeon theme including tileset and darkness settings
var dung_themes = [
{ # 1 - Sandstone
tileset = FAMILY1,
darkness = DARKNESS1
},
{ # 2 - Brick Dark
tileset = FAMILY2,
darkness = DARKNESS2
},
{ # 3 - Bloody Cobbles
tileset = FAMILY3,
darkness = DARKNESS3
},
{ # 4 - Green flagstones
tileset = FAMILY4,
darkness = DARKNESS4
},
{ # 5 - Slime Green
tileset = FAMILY5,
darkness = DARKNESS5
},
{ # 6 - Brown marble
tileset = FAMILY6,
darkness = DARKNESS7
},
{ # 7 - ASCII tiles - used for testing only
tileset = FAMILY6,
darkness = DARKNESS6
}
]


var monster_undead = [
{ # 1st level Undead
minion1 = 'monsters/undead/ghoul_rat',
minion2 = 'monsters/animals/bat',
gribbly1 = 'monsters/undead/zombie',
gribbly2 = 'monsters/undead/diseased_zombie',
boss1 = 'monsters/undead/necromancer'
},
{ # 2nd level Undead
minion1 = 'monsters/undead/lvl2/hell_puppy',
minion2 = 'monsters/animals/lvl2/blood_bat',
gribbly1 = 'monsters/animals/lvl2/scorpion',
gribbly2 = 'monsters/undead/diseased_zombie',
boss1 = 'monsters/undead/necromancer'
}
]

var items_undead = [
{ # 1st level items
rubble = 'items/Rock',
healthpotion = 'items/HealthPotion',
magicitem1 = 'items/Scroll_Confusion',
magicitem2 = 'items/Scroll_LightningBolt',
weapon = 'weapons/crude_dagger',
armour = 'armour/heavy_cloth_armour'
},
{ # 2nd level items
rubble = 'items/Rock',
healthpotion = 'items/HealthPotion',
magicitem1 = 'items/Scroll_Fireball',
magicitem2 = 'items/Scroll_LightningBolt',
weapon = 'weapons/crude_dagger',
armour = 'armour/heavy_cloth_armour'
}
]

var monster_greenskins = [
{ # 1st level Greenskins
minion1 = 'monsters/undead/ghoul_rat',
minion2 = 'monsters/animals/bat',
gribbly1 = 'monsters/undead/zombie',
gribbly2 = 'monsters/undead/diseased_zombie',
boss1 = 'monsters/undead/necromancer'
},
{ # 2nd level Greenskins
minion1 = 'monsters/undead/ghoul_rat',
minion2 = 'monsters/animals/bat',
gribbly1 = 'monsters/undead/zombie',
gribbly2 = 'monsters/undead/diseased_zombie',
boss1 = 'monsters/undead/necromancer'
}
]

var items_greenskins = [
{ # 1st level items
rubble = 'items/Rock',
healthpotion = 'items/HealthPotion',
magicitem1 = 'items/Scroll_Fireball',
magicitem2 = 'items/Scroll_LightningBolt',
weapon = 'weapons/crude_dagger',
armour = 'armour/heavy_cloth_armour'
},
{ # 2nd level items
rubble = 'items/Rock',
healthpotion = 'items/HealthPotion',
magicitem1 = 'items/Scroll_Fireball',
magicitem2 = 'items/Scroll_LightningBolt',
weapon = 'weapons/crude_dagger',
armour = 'armour/heavy_cloth_armour'
}
]
