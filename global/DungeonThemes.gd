extends Node

# Dungeon tiles
const WALL_SANDSTONE = [73, 74,75,76,77,78,79,80,81,82]
const WALL_BRICK_DARK = [65, 66,67,68,69,70,71]
const WALL_STONE_GREY = [87, 88,89, 90]
const WALL_ASCII = [72, 72]
const WALL_SLIME_STONE = [83, 84,85,86]
const WALL_BRICK_BROWN = [57, 58,59,60,61,62,63,64]

const FLOOR_SANDSTONE = [30,31,32,33,34,35,36,37,38, 39]
const FLOOR_BRICK_DARK = [15, 16,17,18,19,20,21]
const FLOOR_COBBLE_BLOOD = [4, 5,6,7,8,9,10,11,12,13,14,91]
const FLOOR_GREEN_SLABS = [40, 41,42,42,44,45,46,47,48,49,50,51,52,53,54,55]
const FLOOR_ASCII = [56,56]
const FLOOR_BOG_GREEN = [0,1,2, 3]
const FLOOR_MARBLE_BROWN = [22, 23,24,25,26,27,28,29]

# Darkness families
var DARKNESS1 = Color( 0.27, 0.27, 0.27, 1 )
var DARKNESS2 = Color( 0.75, 0.59, 0.46, 1 )
var DARKNESS3 = Color( 0.25, 0.32, 0.34, 1 )

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
darkness = DARKNESS3
},
{ # 5 - Slime Green
tileset = FAMILY5,
darkness = DARKNESS3
},
{ # 6 - Brown marble
tileset = FAMILY6,
darkness = DARKNESS3
},
{ # 7 - ASCII tiles - used for testing only
tileset = FAMILY7,
darkness = DARKNESS3
}
]

######## Undead
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
gribbly2 = 'monsters/undead/lvl2/ghoul',
boss1 = 'monsters/undead/lvl2/necromancer2'
},
{ # 3rd level Undead
minion1 = 'monsters/undead/lvl3/demonic_puppy',
minion2 = 'monsters/animals/lvl3/vampire_bat',
gribbly1 = 'monsters/undead/lvl3/vampire',
gribbly2 = 'monsters/undead/lvl3/patchwork_golem',
boss1 = 'monsters/undead/lvl3/zombie_warrior'
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
healthpotion = 'items/GreaterHealthPotion',
magicitem1 = 'items/Scroll_Fireball',
magicitem2 = 'items/Scroll_LightningBolt',
weapon = 'weapons/bone_dagger',
armour = 'armour/bone_armour'
},
{ # 3rd level items
rubble = 'items/Rock',
healthpotion = 'items/GreaterHealthPotion',
magicitem1 = 'items/Scroll_Fireball',
magicitem2 = 'items/Scroll_LightningBolt',
weapon = 'weapons/bone_dagger',
armour = 'armour/bone_armour'
}
]

var traps_undead = [
{ # Level 1
t_e1 = 'traps/web',
t_e2 = 'traps/fungus_trap'
},
{ # Level 2
t_e1 = 'monsters/fungus/yellow_fungus',
t_e2 = 'traps/fungus_trap'
},
{ # Level 3
t_e1 = 'traps/web',
t_e2 = 'traps/fungus_trap'
}
]

var npc_undead = [
{ # Level 1
t_e1 = 'monsters/trolls/rock_troll',
t_e2 = 'monsters/animals/lvl2/scorpion'
},
{ # Level 2
t_e1 = 'monsters/fey/lvl2/pixie_beserker',
t_e2 = 'monsters/animals/lvl2/scorpion'
},
{ # Level 3
t_e1 = 'monsters/greenskins/lvl2/goblin',
t_e2 = 'monsters/undead/lvl3/patchwork_bride'
}
]

###### Greenskins

var monster_greenskins = [
{ # 1st level Greenskins
minion1 = 'monsters/fey/fairy_assassin',
minion2 = 'monsters/fungus/yellow_fungus',
gribbly1 = 'monsters/greenskins/witch_doctor',
gribbly2 = 'monsters/greenskins/rock_thrower_goblin',
boss1 = 'monsters/animals/rat'
},
{ # 2nd level Greenskins
minion1 = 'monsters/fungus/lvl2/mushroom_person',
minion2 = 'monsters/animals/lvl2/ratling',
gribbly1 = 'monsters/greenskins/lvl2/shaman',
gribbly2 = 'monsters/greenskins/lvl2/goblin_warrior',
boss1 = 'monsters/greenskins/lvl2/orc_warrior'
},
{ # 3rd level Greenskins
minion1 = 'monsters/fungus/lvl3/mushroom_person',
minion2 = 'monsters/fey/lvl3/pixie_warrior',
gribbly1 = 'monsters/animals/lvl3/rabid_wolf',
gribbly2 = 'monsters/greenskins/lvl3/goblin_warrior',
boss1 = 'monsters/greenskins/lvl3/orc_warrior'
}
]

var items_greenskins = [
{ # 1st level items
rubble = 'items/Rock',
healthpotion = 'items/HealthPotion',
magicitem1 = 'items/Scroll_LightningBolt',
magicitem2 = 'items/Scroll_Confusion',
weapon = 'weapons/crude_dagger',
armour = 'armour/heavy_cloth_armour'
},
{ # 2nd level items
rubble = 'items/Rock',
healthpotion = 'items/GreaterHealthPotion',
magicitem1 = 'items/Scroll_Fireball',
magicitem2 = 'items/StealthPotion',
weapon = 'weapons/club',
armour = 'armour/crude_leather_armour'
},
{ # 3rd level items
rubble = 'items/Rock',
healthpotion = 'items/GreaterHealthPotion',
magicitem1 = 'items/Scroll_Fireball',
magicitem2 = 'items/Scroll_LightningBolt',
weapon = 'weapons/club',
armour = 'armour/fine_leather_armour'
}
]

var traps_greenskins = [
{ # Level 1
t_e1 = 'traps/web',
t_e2 = 'traps/fungus_trap'
},
{ # Level 2
t_e1 = 'monsters/fungus/lvl2/goblin_mushroom',
t_e2 = 'traps/fungus_trap'
},
{ # Level 3
t_e1 = 'monsters/fungus/lvl2/goblin_mushroom',
t_e2 = 'traps/fungus_trap'
},
]

var npc_greenskins = [
{ # Level 1
t_e1 = 'monsters/greenskins/goblin',
t_e2 = 'monsters/fey/lvl2/pixie_beserker'
},
{ # Level 2
t_e1 = 'monsters/greenskins/lvl2/goblin',
t_e2 = 'monsters/animals/lvl2/scorpion'
},
{ # Level 3
t_e1 = 'monsters/fungus/lvl3/matango',
t_e2 = 'monsters/fungus/lvl3/matango'
}
]
