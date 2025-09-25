extends Node

const DEFAULT_3D_FOV : float = 75.0

const DEFAULT_ZOOM : Vector2 = Vector2(1.0, 1.0)
const DEFAULT_POSITION_2D : Vector2 = Vector2(960.0, 540.0)
const DEFAULT_OFFSET := Vector3(0.0, 0.0, 0.0)
var offset := Vector3(0.0, 0.0, 0.0)

var new_2d_offset : Vector2 = Vector2(0, 0)

@export var camera2D : Camera2D

@export var camera3D : Camera3D

func _on_card_manager_drag_started(card) -> void:
	camera2D.position_smoothing_enabled = true
	match card.targeting:
		"Enemy":
			var position = get_viewport().size / 2
			position.x = position.x * 0.5
			position.y = 0
			offset = Vector3(10.0, 0.0, -5.0)
			zoom_cameras(position)
		"Friendly":
			var position = get_viewport().size / 2
			position.x = position.x * -0.5
			position.y = 0
			offset = Vector3(-10, 0.0, -5.0)
			zoom_cameras(position)
		"Enemy_All":
			var position = get_viewport().size / 2
			position.x = position.x * 0.5
			position.y = 0
			offset = Vector3(20.0, 0.0, -5.0)
			zoom_cameras(position)
		"Friendly_All":
			var position = get_viewport().size / 2
			position.x = position.x * 0.5
			offset = Vector3(-10.0, 0.0, -5.0)
			zoom_cameras(position)
	

func _on_card_manager_drag_finished() -> void:
	camera2D.zoom = DEFAULT_ZOOM
	camera3D.fov = DEFAULT_3D_FOV
	camera2D.position = DEFAULT_POSITION_2D
	new_2d_offset = Vector2(0, 0)
	offset = DEFAULT_OFFSET

func reset_camera(smoothing : bool) -> void:
	if !smoothing: 
		camera2D.position_smoothing_enabled = false
		camera2D.zoom = DEFAULT_ZOOM
		camera3D.fov = DEFAULT_3D_FOV
		camera2D.position = DEFAULT_POSITION_2D
		offset = DEFAULT_OFFSET
	else:
		camera2D.position_smoothing_enabled = true
		camera2D.zoom = DEFAULT_ZOOM
		camera3D.fov = DEFAULT_3D_FOV
		camera2D.position = DEFAULT_POSITION_2D
		offset = DEFAULT_OFFSET

func zoom_cameras(position):
	new_2d_offset = position
	camera2D.zoom = Vector2(1.1, 1.1)
	
	camera3D.fov = 60

func _process(delta: float):
	camera3D.position = camera3D.position.lerp(offset, 5.0 * delta)
	camera2D.offset = camera2D.offset.lerp(new_2d_offset, 10 * delta)

func connect_signals(card_manager):
	card_manager.connect("drag_started", _on_card_manager_drag_started)
	card_manager.connect("drag_finished", _on_card_manager_drag_finished)

func focus_camera_2d(pos : Vector2):
	camera2D.position = pos
