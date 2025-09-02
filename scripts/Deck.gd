extends Node2D

const CARD_SCENE_PATH := "res://scenes/card.tscn"
const CARD_DRAW_SPEED := 0.2


var player_deck := ["Screech", "Heal", "Attack", "Attack", "Attack", "Attack", "Attack", "Attack", "Attack", "Attack"]
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
	
	new_card.get_node("CardImage/Attack").text = str(card_database_reference.CARDS[card_drawn_values][0])
	new_card.value = card_database_reference.CARDS[card_drawn_values][0]
	new_card.get_node("CardImage/Cost").text = str(card_database_reference.CARDS[card_drawn_values][1])
	new_card.cost = card_database_reference.CARDS[card_drawn_values][1]
	var pos = new_card.global_position
	$"../PlayerHand".add_child(new_card)
	new_card.connect_signals()
	new_card.name = "Card"
	new_card.card_name = card_drawn_values #name used for card database reference
	new_card.global_position = pos
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)

func turn_end() -> void:
	if player_deck.size() >= 0:
		for i in range(0, 5):
			self.draw_card()
