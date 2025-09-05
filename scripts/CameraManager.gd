extends Node

const DEFAULT_3D_FOV : float = 75.0

const DEFAULT_ZOOM : Vector2 = Vector2(1.0, 1.0)

@onready var camera2D : Camera2D = $"../Control/Camera2D"

@onready var camera3D : Camera3D = $"../DirectionalLight3D/Camera3D"

func _on_card_manager_drag_started() -> void:
	return
	camera2D.zoom = Vector2(2.0, 2.0)
	camera3D.fov = 50.0


func _on_card_manager_drag_finished() -> void:
	return
	camera2D.zoom = DEFAULT_ZOOM
	camera3D.fov = DEFAULT_3D_FOV
