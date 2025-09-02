extends Node2D

var max_energy
var energy_amt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_energy = 3
	energy_amt = 3
	$EnergyText.text = str(energy_amt)

func get_energy():
	return energy_amt

func add_energy(value: int):
	energy_amt += value
	$EnergyText.text = str(energy_amt)

func decr_energy(value:int):
	energy_amt -= value
	$EnergyText.text = str(energy_amt)


func _on_turn_manager_turn_end() -> void:
	energy_amt = max_energy
	$EnergyText.text = str(energy_amt)
