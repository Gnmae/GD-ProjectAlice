extends Node2D

var card_in_slot = false
var unit_reference

func _ready() -> void:
	unit_reference = get_parent()

func play_card(card):
	unit_reference.apply_effect(card.stats)

func get_group():
	return unit_reference.get_groups()[0]

func show_selector():
	$CardSlotImage.visible = true

func hide_selector():
	$CardSlotImage.visible = false


func _on_area_2d_mouse_entered() -> void:
	$CardSlotImage.visible = true


func _on_area_2d_mouse_exited() -> void:
	$CardSlotImage.visible = false
