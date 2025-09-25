extends Node2D
class_name Enemy

var health
var has_symbol : bool = false

func _ready() -> void:
	health = 2
	$Health.text = str(health)

func apply_effect(cardstats : CardStats):
	health += cardstats.health
	health -= cardstats.damage
	if health <= 0:
		var enemy_manager = get_tree().get_first_node_in_group("EnemyManager")
		enemy_manager.check_enemies()
		queue_free()
	$Health.text = str(health)
