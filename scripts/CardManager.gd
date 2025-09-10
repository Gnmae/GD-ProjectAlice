extends Control

const COLLISION_MASK_CARD : int = 1
const COLLISION_MASK_CARD_SLOT : int = 2
const DEFAULT_CARD_MOVE_SPEED := 0.1

const default_scale := Vector2(0.2, 0.2)

signal drag_started
signal drag_finished

var screen_size
var card_being_dragged
var is_hovering_on_card
var focused: bool = false
var index : int = 0

var player_hand_reference
var discard_pile_reference
var energy_reference



func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	discard_pile_reference = $"../DiscardPile"
	energy_reference = $"../Energy"
	#$"../InputManager".connect("left_mouse_button_released", on_left_click_released)

func on_card_pressed(card, input):
	match input:
		"lmb":
			if !focused:
				start_drag(card)



func start_drag(card):
	focused = true
	card_being_dragged = card
	card_being_dragged.start_focus()
	index = player_hand_reference.find_index(card_being_dragged)
	player_hand_reference.remove_card_from_hand(card_being_dragged)
	emit_signal("drag_started", card)

func finish_drag():
	if !card_being_dragged:
		print("Error card_being_dragged = null in card_manager")
		return
	emit_signal("drag_finished")
	
	var card_slot_found = raycast_check_for_card_slot()
	
	match card_being_dragged.targeting:
		"Enemy":
			if card_slot_found != null and card_slot_found.get_group() == "Enemy" and card_being_dragged.cost <= energy_reference.get_energy():
				#player_hand_reference.remove_card_from_hand(card_being_dragged)
				card_being_dragged.position = card_slot_found.global_position
				card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
				card_slot_found.play_card(card_being_dragged)
				discard_pile_reference.add_to_pile(card_being_dragged.card_name)
				energy_reference.decr_energy(card_being_dragged.cost)
				card_being_dragged.queue_free()
			else:
				card_being_dragged.end_focus()
				player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED, index)
		"Enemy_All":
			if card_being_dragged.cost <= energy_reference.get_energy():
				var enemies = get_tree().get_nodes_in_group("Enemy")
				#player_hand_reference.remove_card_from_hand(card_being_dragged)
				for i in enemies:
					i.get_node("CardSlot").play_card(card_being_dragged)
				discard_pile_reference.add_to_pile(card_being_dragged.card_name)
				energy_reference.decr_energy(card_being_dragged.cost)
				#player_hand_reference.update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
				card_being_dragged.queue_free()
			else:
				card_being_dragged.end_focus()
				player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED, index)
		"Friendly":
			if card_slot_found != null and card_slot_found.get_group() == "Friendly" and card_being_dragged.cost <= energy_reference.get_energy():
				#player_hand_reference.remove_card_from_hand(card_being_dragged)
				card_being_dragged.position = card_slot_found.global_position
				card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
				card_slot_found.play_card(card_being_dragged)
				discard_pile_reference.add_to_pile(card_being_dragged.card_name)
				energy_reference.decr_energy(card_being_dragged.cost)
				card_being_dragged.queue_free()
			else:
				card_being_dragged.end_focus()
				player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED, index)
		"Friendly_All":
			pass
		"All":
			pass
		_:
			pass
	
	await get_tree().create_timer(0.1).timeout
	focused = false
	card_being_dragged = null
	return false

func cancel_drag():
	emit_signal("drag_finished")
	if !card_being_dragged:
		print("Error card_being_dragged = null in card_manager")
		return false
	card_being_dragged.end_focus()
	player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED, index)
	focused = false
	return false

func connect_card_signals(card):
	pass
	#card.connect("hovered", on_hovered_over_card)
	#card.connect("hovered_off", on_hovered_off_card)



func on_hovered_over_card(card):
	if is_hovering_on_card == false:
		is_hovering_on_card = true
		highlight_card(card, true)
	

func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		
		var new_card_hovered = get_rect().has_point(get_viewport().get_mouse_position())
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.z_index = 2
		card.change_scale(Vector2(0.45, 0.45))
	else:
		card.z_index = 1
		card.change_scale(Vector2(0.4, 0.4))

func raycast_check_for_card_slot():
	var offset = Vector2(0.0, 0.0)
	match card_being_dragged.targeting:
		"Enemy":
			offset = get_viewport().size*0.25
			offset.y = 0
		"Friendly":
			offset = get_viewport().size*-0.25
			offset.y = 0
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position() + offset
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
