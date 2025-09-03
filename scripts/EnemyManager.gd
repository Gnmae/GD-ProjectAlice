extends Node2D

const CARD_DATABASE_REFERENCE = "res://resources/cards/"

var enemy_actions = []
var player_reference

func _ready() -> void:
	
	player_reference = $"../Player"

func decide_enemy_actions():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for i in enemies:
		#choose actions randomly from array
		var index := randi_range(0, i.actions.size()-1)
		enemy_actions.append(i.actions[index])
		#action symbols
		update_symbols(i, i.actions[index])

func perform_enemy_actions():
	for i in enemy_actions:
		var card_stats_reference = load(CARD_DATABASE_REFERENCE + i + "Card_Stats.tres")
		player_reference.apply_effect(card_stats_reference)
	enemy_actions.clear()
	self.decide_enemy_actions()

func update_symbols(enemy_reference, action):
	var card_stats_reference = load(CARD_DATABASE_REFERENCE + action + "Card_Stats.tres")
	enemy_reference.get_node("AttackSymbol").visible = true
	enemy_reference.get_node("AttackSymbol/Label").text = str(card_stats_reference.damage)

func _on_turn_manager_turn_end() -> void:
	self.perform_enemy_actions()
