extends Node2D

@export var card_spacing = 220

@onready var hand = $Hand  # Parent node where cards in the hand will be added
@onready var board = $Board  # Parent node where cards in the hand will be added
@onready var graveyard = $Graveyard  # Parent node where cards in the hand will be added

var last_card_correct: bool
signal change_turn(last_card_correct:bool)

var cards : Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	pass # Replace with function body.

var last_added_card: Card = null  # Keep track of the last card added

func _on_child_entered_tree(node: Node) -> void:
	if node is Card:  # Ensure the node added is a card
		last_added_card = node  # Store the last card added
		print(last_added_card)
		print("Last added card: ", last_added_card.get_node("Card_Template/Card_Date"))
	#organize_cards()

#func _on_child_exiting_tree(node: Node) -> void:
	#organize_cards()

func _on_child_order_changed(node: Node) -> void:
	organize_cards()

var is_reorganizing = false  # Flag to prevent recursive calls

func organize_cards():
	#GameControl.player_turn = false
	# Get all cards in the hand
	#print("position in organize:")
	#print(global_position)

	cards.clear()

	for child in get_children():
		if child is Card:
			cards.append(child)

	# Order cards by their actual (current) world positions
	cards.sort_custom(position_comparator)

	# Layout cards in user-determined order
	var card_count = len(cards)

	var current_x = card_spacing * card_count * -0.5

	for card in cards:
		card.go_to_position(Vector2(current_x, 0))
		current_x += card_spacing  # Move to the next position
	# all cards on board 
	# now evaluation
	# wait 2 seconds
	await get_tree().create_timer(2.0).timeout 
	
# Check if the dates are sorted
	var date_array = []
	for card in cards:
		var card_date_label = card.get_node("Card_Template/Card_Date")
		if card_date_label:
			date_array.append(card_date_label.text)  # Add the date to the array

	var out_of_order_index = is_sorted_date_array(date_array)

	if out_of_order_index != -1:  # If there's an out-of-order card
		
		#ameControl.player_turn = false
		# show user it was wrong
		var card_marked_wrong = last_added_card.get_node("Wrong")
		card_marked_wrong.visible = true
		
		await get_tree().create_timer(2.0).timeout 
		var graveyard = get_graveyard()
		# funktioniert - now wait 2sec
		##################################
		last_added_card.get_parent().remove_child(last_added_card)
		
		if graveyard:
			graveyard.add_child(last_added_card)
			last_added_card.global_position = graveyard.position
			last_added_card.remove_from_group("board_cards")
			last_added_card.add_to_group("graveyard_cards")
			card_marked_wrong.visible = false
			await get_tree().create_timer(2.0).timeout 
			
			last_card_correct = false
			
			#GameControl.player_turn = false
			
			emit_signal("change_turn", last_card_correct)
			
	elif last_added_card.is_in_group("board_cards"):
		var card_marked_right = last_added_card.get_node("Right")
		card_marked_right.visible = true
		await get_tree().create_timer(2.0).timeout 
		print("The date array is sorted.")
		card_marked_right.visible = false
		await get_tree().create_timer(2.0).timeout 
		
		last_card_correct = true
		#GameControl.player_turn = false
		emit_signal("change_turn", last_card_correct)

	
func position_comparator(a : Card, b: Card) -> bool:
	return a.original_position.x < b.original_position.x


func is_sorted_date_array(date_array: Array) -> int:
	for i in range(date_array.size() - 1):
		if date_array[i] > date_array[i + 1]:  # Detect out-of-order date
			return i + 1  # Return the index of the problematic card
	return -1  # If sorted, return -1
	
func get_graveyard() -> Node2D:
	return get_tree().root.get_node("Main/Graveyard")  # Adjust the path as needed
