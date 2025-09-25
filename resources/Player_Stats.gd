class_name PlayerStats
extends Resource

signal stats_changed

#combat-related stats
@export var max_health : int
@export var health : int = 0
@export var max_energy : int
@export var energy : int = 0
@export var deck : Array[String]

#resources
@export var currency : int

func reset():
	set_energy(max_energy)
	emit_signal("stats_changed")

func set_health(amount: int):
	health = amount

func set_energy(amount: int):
	energy = amount

func add_currency(amount: int):
	currency += amount
	emit_signal("stats_changed")

func add_energy_clamped(amount : int):
	var tmp = energy + amount
	energy = clampi(tmp, 1, max_energy)
	emit_signal("stats_changed")

func add_energy(amount : int):
	energy += amount
	emit_signal("stats_changed")

func decr_energy(amount: int):
	var tmp = energy - amount
	energy = clampi(tmp, 0, max_energy)
	emit_signal("stats_changed")
