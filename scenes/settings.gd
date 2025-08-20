extends Control

var screen_size

func _ready() -> void:
	screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	var center_x = (screen_size.x - window_size.x) / 2
	var center_y = (screen_size.y - window_size.y) / 2
	
	DisplayServer.window_set_position(Vector2i(center_x, center_y))

func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
	var window_size = DisplayServer.window_get_size()
	var center_x = (screen_size.x - window_size.x) / 2
	var center_y = (screen_size.y - window_size.y) / 2
	
	DisplayServer.window_set_position(Vector2i(center_x, center_y))

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
