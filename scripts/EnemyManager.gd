extends Node2D

var enemy_actions = []
var card_database_reference
var player_reference

func _ready() -> void:
	card_database_reference = preload("res://scripts/CardDatabase.gd")
	player_reference = $"../Player"

func decide_enemy_actions():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for i in enemies:
		#choose actions randomly from array
		var index := randi_range(0, i.actions.size()-1)
		enemy_actions.append(i.actions[index])

func perform_enemy_actions():
	for i in enemy_actions:
		player_reference.take_damage(card_database_reference.CARDS.get(i)[0])
	self.decide_enemy_actions()


func _on_turn_manager_turn_end() -> void:
	self.perform_enemy_actions()
