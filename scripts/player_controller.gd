extends Node2D

@onready var stats : PlayerStats = preload("res://resources/player_stats.tres")
@onready var turn_manager := $CanvasLayer/TurnManager

var player_ui

var player

var max_health 
var health 
var max_energy 
var energy
var deck 

func _ready() -> void:
	player_ui = get_tree().get_first_node_in_group("PlayerUI")
	
	stats.connect("stats_changed", update_stats)
	$CanvasLayer.visible = false
	turn_manager.connect("turn_end", end_turn)

func initialize():
	player = get_tree().get_first_node_in_group("Friendly")
	init_stats()
	update_stats()
	player.initialize(max_health, health, self)
	$CanvasLayer.visible = true
	$CanvasLayer/Deck.initialize(deck)
	$CanvasLayer/DiscardPile.clear_pile()
	$CanvasLayer/TurnManager.initialize()

func init_stats():
	stats.reset()

func update_stats():
	max_energy = stats.max_energy
	max_health = stats.max_health
	health = max_health
	energy = stats.energy
	deck = stats.deck.duplicate()
	player_ui.set_coin_text(str(stats.currency))
	$CanvasLayer/Energy.update_energy_text(energy, max_energy)

func end_turn():
	stats.add_energy_clamped(stats.max_energy)

func show_player_controller():
	$CanvasLayer.visible = true

func hide_player_controller():
	$CanvasLayer/PlayerHand.clear_hand()
	$CanvasLayer.visible = false

func clear_player_hand():
	$CanvasLayer/PlayerHand.clear_hand()

func connect_player_signals(player):
	player.connect("health_updated", _on_player_health_updated)

func _on_player_health_updated():
	health = player.health

func rest():
	health += clampi(30, 0, max_health)
