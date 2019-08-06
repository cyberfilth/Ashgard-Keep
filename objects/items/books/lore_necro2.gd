extends Node2D

var book_contents = ["\"As it is written in the Book of "+PlotGen.mage+".\nA warrior wins when he learns when to fight,\n...and when not to fight.\"",\
"\"...because I found that although a full frontal attack is often enough,\nusing stealth to avoid fights is sometimes the only way to avoid death.\"\n - Taken from the notes of Davgrim Skaldsonne, Master Necromancer",
"Excerpt from the Bestiary of "+PlotGen.mage+".\n\"Hell puppies are a combination of cute and annoying... when they are small,\nbut a full-grown Hell Hound is a different beast altogether.\"",
"\"...the light is hateful to us who live in the total darkness of this Keep.\nIn the darkness we are faster. Stronger. Intruders are only safe whilst they hold a lit torch in their hand...\""]

func _ready():
	pass

func read_book():
	var passage = book_contents[GameData.roll(0, book_contents.size()-1)]
	GameData.broadcast("You read a passage from the book...", GameData.COLOR_LIGHT_BLUE)
	GameData.broadcast(passage, GameData.COLOR_YELLOW)
	boost_stat()

func boost_stat():
	var boost = GameData.roll(0,2)
	if boost == 0:
		GameData.broadcast("Your new knowledge inspires you. Your attack strength has increased +1", GameData.COLOR_GREEN)
		GameData.player.fighter.attack += 1
	if boost == 1:
		GameData.broadcast("A new determination fills you. Your defence ability has increased +1", GameData.COLOR_GREEN)
		GameData.player.fighter.defence += 1
	if boost == 2:
		GameData.broadcast("The power of the written runes changes you. Your Max Health has increased +10", GameData.COLOR_GREEN)
		GameData.player.fighter.max_hp += 10
