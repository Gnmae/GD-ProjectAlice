extends Control

var action_done : bool = false

var player

func _ready():
	player = get_tree().get_first_node_in_group("PlayerController")

func _on_rest_pressed() -> void:
	action_done = true
	$VBoxContainer/HBoxContainer/Upgrade.disabled = true
	player.rest()

func _on_upgrade_pressed() -> void:
	action_done = true
	$VBoxContainer/HBoxContainer/Rest.disabled = true

func _on_leave_pressed() -> void:
	if action_done:
		get_tree().get_first_node_in_group("GameController").rest_finished()
