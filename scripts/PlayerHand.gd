extends Control

const CARD_WIDTH := 210
const HAND_Y_POSITION := 900
const DEFAULT_CARD_MOVE_SPEED := 0.1
const SIZE := Vector2(1400, 300)

var player_hand = []
var center_screen_x
var discard_pile_reference
var deck_reference

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep := -10
@export var y_min := 0
@export var y_max := -30

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	discard_pile_reference = $"../DiscardPile"
	deck_reference = $"../Deck"
	#var card_scene = preload(CARD_SCENE_PATH)
	#for i in range(HAND_COUNT): 
		#var new_card = card_scene.instantiate()
		#$"../CardManager".add_child(new_card)
		#new_card.name = "Card"
		#add_card_to_hand(new_card)

func clear_hand():
	for i in player_hand.duplicate():
		self.discard_card_from_hand(i)

func add_card_to_hand(card, speed, index):
	if card not in player_hand:
		player_hand.insert(index, card)
		card.reparent(self)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)
		#update_hand_positions(speed)

func find_index(card):
	for i in player_hand.size():
		if player_hand[i] == card:
			return i
	return 0

func discard_card_from_hand(card):
	discard_pile_reference.add_to_pile(card.card_name)
	player_hand.erase(card)
	var root = get_tree().current_scene
	card.reparent(root)
	await animate_card_to_position(card, discard_pile_reference.global_position, 0.2)
	card.queue_free()



func update_hand_positions(speed):
	var card_count := player_hand.size()
	var all_cards_size := Card.SIZE.x * card_count + x_sep * (card_count-1)
	var final_x_sep : float = x_sep
	
	if all_cards_size > SIZE.x:
		final_x_sep = (SIZE.x - Card.SIZE.x * card_count) / (card_count-1)
		all_cards_size = SIZE.x
	
	var offset := (SIZE.x - all_cards_size) / 2
	
	for i in card_count:
		var card = player_hand[i]
		
		var y_multiplier := hand_curve.sample(1.0 / (card_count - 1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (card_count - 1) * i)
		
		if i != player_hand.size()/2:
			if i < player_hand.size()/2:
				rot_multiplier-=0.5
			else:
				rot_multiplier +=0.5
		
		if card_count == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0
		
		var final_x: float = offset + Card.SIZE.x * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier
		
		var new_position = Vector2(final_x + self.global_position.x, final_y + self.global_position.y)
		card.hand_position = new_position
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
		animate_card_to_position(card, new_position, speed)
	
	
	#for i in range(player_hand.size()):
		#var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		#var card = player_hand[i]
		#card.hand_position = new_position
		#animate_card_to_position(card, new_position, speed)
	#

func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", new_position, speed)
	await tween.finished

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		var card_manager = get_tree().get_first_node_in_group("CardManager")
		card.reparent(card_manager)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)

func turn_end() -> void:
	for i in player_hand.duplicate():
		discard_card_from_hand(i)
	deck_reference.turn_end()
