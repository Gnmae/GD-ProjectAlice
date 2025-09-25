extends Node

var unit_manager
var enemy_manager

func _ready():
	unit_manager = %UnitManager
	enemy_manager = %EnemyManager

func start_encounter(node):
	#unit_manager.initialize()
	enemy_manager.initialize()

func connect_player_signals(player):
	player.connect("player_died", _on_player_death)

func _on_player_death() -> void:
	print("playerdioed")
