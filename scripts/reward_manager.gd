extends Node

@onready var game_controller = $"../GameController"
@onready var gui = $"../GUI"

@onready var reward_ui_scene := preload("res://scenes/reward_ui.tscn")

var reward_ui

func reward_popup():
	reward_ui = reward_ui_scene.instantiate()
	gui.add_child(reward_ui)
	reward_ui.connect_reward_manager(self)
	reward_ui.create_currency_reward()

func end_reward_scene():
	reward_ui.queue_free()
	game_controller.on_reward_selection_finished()
