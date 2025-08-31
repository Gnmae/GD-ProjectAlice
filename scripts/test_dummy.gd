extends Enemy

var actions := ["Attack", "Screech"]

func _ready() -> void:
	health = 10
	$Health.text = str(health)
