extends PanelContainer

onready var frame = get_node('frame')
onready var hpbox = frame.get_node('HP')
onready var statsbox = frame.get_node('stats')
onready var statsleft = statsbox.get_node('left')
onready var statsright = statsbox.get_node('right')


onready var namelabel = frame.get_node('Name')
onready var racelabel = frame.get_node('Race')

onready var currenthplabel = hpbox.get_node('labels/CurrentHP')
onready var maxhplabel = hpbox.get_node('labels/MaxHP')
onready var hpbar = hpbox.get_node('Bar')

onready var levellabel = statsleft.get_node('values/Level')
onready var powerlabel = statsleft.get_node('values/Power')
onready var defenselabel = statsleft.get_node('values/Defense')

onready var xplabel = statsright.get_node('values/XP')
onready var locationlabel = statsright.get_node('values/Location')

func name_changed(what):
	namelabel.set_text(what)

func race_changed(what):
	racelabel.set_text(what)

func hp_changed(current,full):
	currenthplabel.set_text(str(current))
	maxhplabel.set_text(str(full))
	hpbar.set_max(full)
	hpbar.set_value(current)

func _ready():
	pass