extends Control



func _on_start_game_button_pressed() -> void:
	Global.game_manager.start_game()

func _on_options_button_pressed() -> void:
	Global.game_manager.change_gui_scene("res://scenes/settings.tscn", false, true)

func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
