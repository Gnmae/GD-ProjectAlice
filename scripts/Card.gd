class_name Card
extends Node2D
#connects signals to card manager

const SIZE := Vector2(184, 300)
const CARD_Z_INDEX := 5

signal hovered
signal hovered_off

var mouse_in: bool = false
var focused: bool = false

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
var input_manager

func _ready() -> void:
	card_manager = get_tree().get_first_node_in_group("CardManager")
	input_manager = get_tree().get_first_node_in_group("InputManager")

func _physics_process(delta: float) -> void:
	if !card_manager.focused:
		hover_logic(delta)
		input_logic()

func input_logic() -> void:
	if (mouse_in):
		if Input.is_action_just_pressed("lmb"):
			card_manager.on_card_pressed(self, "lmb")

func hover_logic(_delta: float):
	$CardImage/shadow.position = Vector2(12, 12).rotated($CardImage.rotation)
	$CardImage/shadow.modulate.a = 0.5
	if (mouse_in):
		$CardImage.z_index = CARD_Z_INDEX
		change_scale(Vector2(0.43, 0.43))
		
		return 
	
	change_scale(Vector2(0.4, 0.4))
	#$CardImage.rotation_degrees = lerp($CardImage.rotation_degrees, 0.0, 22.0*delta)
	$CardImage/shadow.modulate.a = 0.0
	$CardImage.z_index = 0

func start_focus():
	$CardImage.z_index = CARD_Z_INDEX
	var focused_card_position = Vector2(1920, 1080) / 2.0
	focused_card_position.x = focused_card_position.x * 1.5
	global_position = focused_card_position
	change_scale(Vector2(1.0, 1.0))
	self.rotation_degrees = 0.0
	$CardImage/shadow.modulate.a = 0.5
	$CardImage/Text.visible = true

func end_focus():
	change_scale(Vector2(0.4, 0.4))
	$CardImage/shadow.modulate.a = 0.0
	$CardImage/Text.visible = false
	$CardImage.z_index = 0

func connect_signals() -> void:
	pass
	#card_manager.connect_card_signals(self)
	#input_manager.connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
	emit_signal("hovered_off", self)


func change_scale(desired_scale: Vector2):
	if desired_scale == current_goal_scale:
		return
	
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property($CardImage, "scale", desired_scale, 0.125) #0.125
	
	current_goal_scale = desired_scale

func _set_rotation(_delta: float) -> void:
	#var desired_rotation: float = clamp((global_position - last_pos).x*0.85, -max_card_rotation, max_card_rotation)
	#$CardImage.rotation_degrees = lerp($CardImage.rotation_degrees, desired_rotation, 12.0*delta)
	$CardImage.rotation_degrees = 0.0
	last_pos = global_position

func _start_focus():
	pass
