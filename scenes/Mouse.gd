extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$Sprite2D/shadow.modulate.a = 0.5

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	#global_position = lerp(global_position, get_global_mouse_position(), 90.0*delta)
	rotation_degrees = lerp(rotation_degrees, -12.5 if Input.is_action_pressed("lmb") else 0.0, 16.0*delta)
	scale = lerp(scale, Vector2(0.175, 0.175) if Input.is_action_pressed("lmb") else Vector2(0.2, 0.2), 16.0*delta)
	$Sprite2D/shadow.position = Vector2(12, 12).rotated(rotation)
	
