extends Node2D


var deck_reference
var enemy_manager_reference
var player_hand_reference
var end_turn_button_reference

signal turn_end

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_reference = $"../Deck"
	enemy_manager_reference = $"../EnemyManager"
	player_hand_reference = $"../PlayerHand"
	end_turn_button_reference = $"../EndTurnButton"
	enemy_manager_reference.decide_enemy_actions()
	
	await get_tree().create_timer(0.2).timeout
	for i in range(0,5):
		deck_reference.draw_card()


func _on_end_turn_button_pressed() -> void:
	self.emit_signal("turn_end")
	player_hand_reference.turn_end()
	#deck_reference.turn_end()

func _on_card_manager_drag_finished() -> void:
	end_turn_button_reference.disabled = false

func _on_card_manager_drag_started(card) -> void:
	end_turn_button_reference.disabled = true
