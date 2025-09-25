extends Node

var game_manager

func _ready() -> void:
	game_manager = get_parent()

func initialize(node):
	if node.type == "Combat":
		game_manager.change_3d_scene(node.scene_bg)
		game_manager.change_2d_scene(node.scene)
		game_manager.change_gui_scene("res://scenes/control.tscn", false, true)
		$"../EncounterManager".start_encounter(node)
		$"../CameraManager".reset_camera(false)
		$"../World2D/PlayerController".initialize()
		$"../CanvasLayer/PlayerUI".visible = true
	else:
		game_manager.change_2d_scene(node.scene_bg)
		game_manager.change_gui_scene(node.scene, false, true)
		$"../CameraManager".reset_camera(false)

func encounter_finished():
	$"../World2D/PlayerController".hide_player_controller()
	$"../RewardManager".reward_popup()

func on_reward_selection_finished():
	return_to_node_scene()

func return_to_node_scene():
	$"../World2D/PlayerController".hide_player_controller()
	game_manager.change_2d_scene("res://scenes/test_node_selection_bg.tscn")
	game_manager.change_gui_scene("res://scenes/node_selection_scene.tscn")
	var node_selection_scene = get_parent().saved_gui_scene
	$"../CameraManager".focus_camera_2d(node_selection_scene.curr_node.position)
	%UnitManager.clear_unit_array()

func rest_finished():
	game_manager.change_2d_scene("res://scenes/test_node_selection_bg.tscn")
	game_manager.change_gui_scene("res://scenes/node_selection_scene.tscn")
	var node_selection_scene = get_parent().saved_gui_scene
	$"../CameraManager".focus_camera_2d(node_selection_scene.curr_node.position)
