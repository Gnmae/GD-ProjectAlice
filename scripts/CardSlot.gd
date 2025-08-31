extends Node2D

var card_in_slot = false
var unit_reference

func _ready() -> void:
	unit_reference = get_parent()

func play_card(card):
	unit_reference.take_damage(card.value)
