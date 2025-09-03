extends Node2D

var card_in_slot = false
var unit_reference

func _ready() -> void:
	unit_reference = get_parent()

func play_card(card):
	unit_reference.apply_effect(card.stats)

func get_group():
	return unit_reference.get_groups()[0]
