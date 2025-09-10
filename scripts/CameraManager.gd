extends Node

const DEFAULT_3D_FOV : float = 75.0

const DEFAULT_ZOOM : Vector2 = Vector2(1.0, 1.0)
const DEFAULT_POSITION_2D : Vector2 = Vector2(960.0, 540.0)
const DEFAULT_OFFSET := Vector3(0.0, 0.0, 0.0)
var offset := Vector3(0.0, 0.0, 0.0)

@onready var camera2D : Camera2D = $"../Control/Camera2D"

@onready var camera3D : Camera3D = $"../DirectionalLight3D/Camera3D"

@onready var dir_light : DirectionalLight3D = $"../DirectionalLight3D"

func _on_card_manager_drag_started(card) -> void:
	match card.targeting:
		"Enemy":
			var position = get_viewport().size / 2
			position.x = position.x * 1.5
			offset = Vector3(10.0, 0.0, -5.0)
			zoom_cameras(position)
		"Friendly":
			var position = get_viewport().size / 2
			position.x = position.x * 0.5
			offset = Vector3(-10, 0.0, -5.0)
			zoom_cameras(position)
		"Enemy_All":
			var position = get_viewport().size / 2
			position.x = position.x * 1.5
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
	offset = DEFAULT_OFFSET

func zoom_cameras(position):
	camera2D.position = position
	camera2D.zoom = Vector2(1.1, 1.1)
	
	camera3D.fov = 60

func _process(delta: float):
	camera3D.position = camera3D.position.lerp(offset, 5.0 * delta)
