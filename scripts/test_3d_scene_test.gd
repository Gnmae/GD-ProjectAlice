extends Node3D

func _ready() -> void:
	var new_background = load("res://scenes/wireframe_background.tscn").instantiate()
	self.add_child(new_background)
