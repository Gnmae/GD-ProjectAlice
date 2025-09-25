extends Control

@onready var reward_button_scene := preload("res://scenes/reward_button.tscn")

@onready var reward_container := %RewardContainer
@onready var next_button := %NextButton
var reward_manager

var reward_array = []

func create_currency_reward():
	var new_reward = reward_button_scene.instantiate()
	reward_container.add_child(new_reward)
	reward_array.append(new_reward)
	new_reward.initialize(self, "currency", randi_range(10, 30))

func connect_reward_manager(reward_manager_reference):
	reward_manager = reward_manager_reference

func connect_signals(reward_button):
	reward_button.connect("clicked", give_reward)

func give_reward(button):
	var player_stats := load("res://resources/player_stats.tres")
	if button.reward_type == "currency":
		if button in reward_array:
			player_stats.add_currency(button.amount)
			reward_array.erase(button)
			button.queue_free()

func _on_next_button_pressed() -> void:
	reward_manager.end_reward_scene()
