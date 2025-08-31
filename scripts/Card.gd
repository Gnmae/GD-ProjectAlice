extends Node2D
#connects signals to card manager

signal hovered
signal hovered_off	

var hand_position
var value
var cost
var card_name : String

func _ready() -> void:
	# connect card signals in parent(card manager). 
	# if card is not child of card manager big error
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
