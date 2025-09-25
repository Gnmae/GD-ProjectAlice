extends TextureButton

@onready var rich_text_label := $RichTextLabel

signal clicked

var reward_type : String
var amount := 1

func initialize(reward_manager, type, amt):
	reward_type = type
	amount = amt
	if amount > 1:
		rich_text_label.text = str(amount)
	reward_manager.connect_signals(self)


func _on_pressed() -> void:
	emit_signal("clicked", self)
	print("clicked : reward button")
