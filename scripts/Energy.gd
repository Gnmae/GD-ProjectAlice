extends Node2D


func update_energy_text(energy, max_energy):
	$EnergyText.text = str(energy) + "/" + str(max_energy)
