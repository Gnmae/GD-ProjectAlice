extends Control

const COLLISION_MASK_CARD : int = 1
const COLLISION_MASK_DECK : int = 4

var card_manager_reference
var deck_reference
var focused : bool = false
var mouse_in: bool = false

var card_hovered = null

func _ready() -> void:
	card_manager_reference = $"../CardManager"
	deck_reference = $"../Deck"

func _input(event):
	if card_manager_reference.focused == false:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			card_manager_reference.finish_drag()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		card_manager_reference.cancel_drag()
