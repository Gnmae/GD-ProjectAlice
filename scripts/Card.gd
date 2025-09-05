class_name Card
extends Node2D
#connects signals to card manager

const SIZE := Vector2(184, 300)

signal hovered
signal hovered_off

var mouse_in: bool = false
var is_dragging: bool = false

var current_goal_scale: Vector2 = Vector2(0.4, 0.4)
var scale_tween: Tween

var last_pos: Vector2
var max_card_rotation: float = 12.5

@export var stats : CardStats

var hand_position
var cost
var card_name : String
var targeting

var card_manager

#func _physics_process(delta: float) -> void:
	#if is_dragging:
		#drag_logic()
	#else:
		#hover_logic(delta)

func hover_logic(delta: float) -> void:
	$CardImage/shadow.position = Vector2(12, 12).rotated($CardImage.rotation)
	$CardImage/shadow.modulate.a = 0.5
	if (mouse_in or is_dragging) and (MouseBrain.node_being_dragged == null or MouseBrain.node_being_dragged == self):
		if Input.is_action_just_pressed("lmb"):
			#global_position = lerp(global_position, get_global_mouse_position(), 22.0*delta) # - (SIZE/2.0)
			#_set_rotation(delta)
			is_dragging = true
			MouseBrain.node_being_dragged = self
		else:
			_change_scale(Vector2(0.43, 0.43))
			#$CardImage.rotation_degrees = lerp($CardImage.rotation_degrees, 0.0, 22.0*delta)
			is_dragging = false
			if MouseBrain.node_being_dragged == self:
				MouseBrain.node_being_dragged = null
			
		return 
	
	$CardImage.z_index = 0
	_change_scale(Vector2(0.4, 0.4))
	#$CardImage.rotation_degrees = lerp($CardImage.rotation_degrees, 0.0, 22.0*delta)
	$CardImage/shadow.modulate.a = 0.0

func drag_logic():
	$CardImage.z_index = 100
	var focused_card_position = Vector2(1920, 1080) / 2.0
	focused_card_position.x = focused_card_position.x * 1.5
	global_position = focused_card_position
	_change_scale(Vector2(1.0, 1.0))
	$CardImage.global_rotation_degrees = 0.0

func connect_signals() -> void:
	card_manager = get_tree().get_first_node_in_group("CardManager")
	card_manager.connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
	emit_signal("hovered_off", self)

func _change_scale(desired_scale: Vector2):
	if desired_scale == current_goal_scale:
		return
	
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property($CardImage, "scale", desired_scale, 0.125) #0.125
	
	current_goal_scale = desired_scale

func _set_rotation(delta: float) -> void:
	var desired_rotation: float = clamp((global_position - last_pos).x*0.85, -max_card_rotation, max_card_rotation)
	$CardImage.rotation_degrees = lerp($CardImage.rotation_degrees, desired_rotation, 12.0*delta)
	
	last_pos = global_position

func _start_focus():
	pass
