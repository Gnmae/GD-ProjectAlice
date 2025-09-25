extends Node

var units = []

func instantiate_units(player_scene, enemy_scenes) -> void:
	var player = player_scene
	units.insert(0, player)
	for i in enemy_scenes:
		var new_node = i
		units.insert(0, new_node)

func clear_unit_array() -> void:
	units.clear()
