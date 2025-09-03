extends Node2D
class_name Player

var health


func _ready() -> void:
	health = 50
	$Health.text = str(health)


func apply_effect(cardstats : CardStats):
	health += cardstats.health
	health -= cardstats.damage
	if health <= 0:
		print("player health no good")
	$Health.text = str(health)
