extends Node2D
class_name Player

signal player_died
signal health_updated

var max_health = 0
var health = 0

var encounter_manager

func _ready() -> void:
	encounter_manager = get_tree().get_first_node_in_group("EncounterManager")
	encounter_manager.connect_player_signals(self)


func initialize(max, amt, player_controller):
	max_health = max
	health = amt
	$Health.text = (str(health) + "/" + str(max_health))
	player_controller.connect_player_signals(self)


func apply_effect(cardstats : CardStats):
	health += cardstats.health
	health -= cardstats.damage
	if health <= 0:
		self.emit_signal("player_died")
	$Health.text = (str(health) + "/" + str(max_health))
	self.emit_signal("health_updated")
