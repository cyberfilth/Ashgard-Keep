extends Node2D

var book_contents = ["\"As it is written in the Book of "+PlotGen.mage+".\nVictorius wizards win first, then go to war.\nDefeated wizards go to war first, then try to win.\""]

func _ready():
	pass

func read_book():
	var passage = book_contents[GameData.roll(0, book_contents.size()-1)]
	GameData.broadcast("You read the pages of the book...", GameData.COLOR_LIGHT_BLUE)
	GameData.broadcast(passage, GameData.COLOR_YELLOW)
