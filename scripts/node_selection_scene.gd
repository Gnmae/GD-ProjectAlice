extends Control

@onready var node_button = preload("res://scenes/node.tscn")

const NUMBER_OF_COLUMNS : int = 6
const NUMBER_OF_ROWS : int = 3

const REST_COLUMNS : int = 2

var node_scenes := ["res://scenes/test_combat_scene.tscn", "res://scenes/test_3d_scene_test.tscn"]
var rest_scene := ["res://scenes/rest_scene_ui.tscn", "res://scenes/rest_scene_test_bg.tscn"]

var camera_manager
var game_controller

var confirm_button

var previewing_node : bool = false

var curr_column : int = -1
var prev_node = null
var curr_node = null

func _ready() -> void:
	confirm_button = $CanvasLayer/Button
	
	for i in range(0, NUMBER_OF_COLUMNS):
		
		var nodes_in_column = randi_range(1, NUMBER_OF_ROWS)
		if i%REST_COLUMNS == 0 and i != 0:
			var new_node = node_button.instantiate()
			self.add_child(new_node)
			new_node.position = Vector2(i * 300.0, 300.0)
			new_node.column = i
			new_node.scene = rest_scene[0]
			new_node.scene_bg = rest_scene[1]
			new_node.type = "Rest"
			var label = new_node.get_child(0)
			label.text = "Rest"
			nodes_in_column = 0
		if nodes_in_column == 1:
			instantiate_node(Vector2(i*300.0, 300.0), i)
		elif nodes_in_column == 2:
			for j in range(0, nodes_in_column):
				instantiate_node(Vector2(i*300.0, (j*300.0) + 150.0), i)
		else:
			for j in range(0, nodes_in_column):
				instantiate_node(Vector2(i*300.0, j*300.0), i)
	
	camera_manager = get_tree().get_first_node_in_group("CameraManager")
	camera_manager.focus_camera_2d(Vector2(0, 300))
	
	game_controller = get_tree().get_first_node_in_group("GameController")

func instantiate_node(position : Vector2, column):
	var new_node = node_button.instantiate()
	self.add_child(new_node)
	new_node.position = position
	new_node.column = column
	new_node.scene = node_scenes[0]
	new_node.scene_bg = node_scenes[1]
	new_node.type = "Combat"

func node_pressed(node):
	if node.column == curr_column + 1:
		curr_node = node
		camera_manager.focus_camera_2d(node.position)
		confirm_button.visible = true
		previewing_node = true
	elif node == prev_node and previewing_node:
		curr_node = node
		camera_manager.focus_camera_2d(node.position)
		confirm_button.visible = false
		previewing_node = false

func _on_button_pressed() -> void:
	if previewing_node:
		prev_node = curr_node
		curr_column += 1
		confirm_button.visible = false
		previewing_node = false
		
		game_controller.initialize(curr_node)
