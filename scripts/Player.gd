extends Node2D
class_name Player

var health


func _ready() -> void:
	health = 50
	$Health.text = str(health)


func take_damage(value : int):
	if value >= health:
		print("player health no good")
	health -= value
	$Health.text = str(health)
