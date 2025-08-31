extends Node2D

var discard_pile = []

func add_to_pile(card_name : String):
	discard_pile.append(card_name)

func get_pile():
	return discard_pile

func clear_pile():
	discard_pile.clear()
