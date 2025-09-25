class_name GameManager extends Node

@export var world_3d : Node3D
@export var world_2d : Node2D
@export var gui : Control

var current_3d_scene
var current_2d_scene
var current_gui_scene

var saved_gui_scene

func _init() -> void:
	Global.game_manager = self

func _ready() -> void:
	current_gui_scene = $GUI/MainMenu

func change_3d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_3d_scene != null:
		if delete:
			current_3d_scene.queue_free()
		elif keep_running:
			current_3d_scene.visible = false
		else:
			world_3d.remove_child(current_3d_scene)
	var new_3d_scene = load(new_scene).instantiate()
	world_3d.add_child(new_3d_scene)
	current_3d_scene = new_3d_scene

func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	var new_2d_scene = load(new_scene).instantiate()
	world_2d.add_child(new_2d_scene)
	current_2d_scene = new_2d_scene

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
			saved_gui_scene = current_gui_scene
		else:
			gui.remove_child(current_gui_scene)
	if saved_gui_scene and new_scene == saved_gui_scene.scene_file_path:
		saved_gui_scene.visible = true
		current_gui_scene = saved_gui_scene
	else:
		var new_gui_scene = load(new_scene).instantiate()
		gui.add_child(new_gui_scene)
		current_gui_scene = new_gui_scene 

func start_game() -> void:
	change_gui_scene("res://scenes/node_selection_scene.tscn")
	change_2d_scene("res://scenes/test_node_selection_bg.tscn")
