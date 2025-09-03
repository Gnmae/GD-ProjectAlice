extends Node2D

const CARD_SCENE_PATH := "res://scenes/card.tscn"
const CARD_DRAW_SPEED := 0.2


var player_deck := ["Screech", "Heal", "Shockwave", "Attack", "Attack", "Attack", "Attack", "Attack", "Attack", "Attack"]
var card_database_reference
var discard_pile_reference
var player_hand_reference

func _ready() -> void:
	player_hand_reference = $"../PlayerHand"
	discard_pile_reference = $"../DiscardPile"
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://scripts/CardDatabase.gd")

func draw_card():
	
	if player_deck.size() == 0:
		var discard_pile = discard_pile_reference.get_pile()
		if discard_pile.size() == 0:
			return
		for i in discard_pile:
			player_deck.append(i)
		discard_pile_reference.clear_pile()
	
	if player_deck.size() == 0:
			return
	
	var card_drawn_values = player_deck[0] #[atk value, cost]
	player_deck.erase(card_drawn_values)
	
	$RichTextLabel.text = str(player_deck.size()	)
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://assets/" + card_drawn_values + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	var card_resource_path = str("res://resources/cards/" + card_drawn_values + "Card_Stats.tres")
	new_card.stats = load(card_resource_path)
	
	new_card.get_node("CardImage/Attack").text = str(new_card.stats.damage)
	new_card.get_node("CardImage/Cost").text = str(new_card.stats.cost)
	new_card.cost = new_card.stats.cost
	
	var pos = new_card.global_position
	$"../PlayerHand".add_child(new_card)
	new_card.connect_signals()
	new_card.name = "Card"
	new_card.card_name = card_drawn_values #name used for card database reference
	new_card.targeting = new_card.stats.targeting
	new_card.global_position = pos
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)

func turn_end() -> void:
	if player_deck.size() >= 0:
		for i in range(0, 5):
			self.draw_card()
