extends Node2D
class_name Enemy

var health

func _ready() -> void:
	health = 2
	$Health.text = str(health)

func take_damage(value):
	if value >= health:
		queue_free()
	health -= value
	$Health.text = str(health)
