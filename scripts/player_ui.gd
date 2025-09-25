extends Control

@onready var coin_icon := $VBoxContainer/TextureRect/BoxContainer/HBoxContainer/CoinIcon
@onready var coin_text := $VBoxContainer/TextureRect/BoxContainer/HBoxContainer/CoinText

func set_coin_text(text : String):
	coin_text.text = text
