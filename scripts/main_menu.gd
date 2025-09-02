extends Control


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_combat_scene.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
