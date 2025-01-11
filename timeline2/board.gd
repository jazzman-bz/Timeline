extends Node2D


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


func _on_child_entered_tree(node: Node) -> void:
	organize_cards()


func _on_child_exiting_tree(node: Node) -> void:
	organize_cards()
var is_reorganizing = false  # Flag to prevent recursive calls

func organize_cards():
	# Get all cards in the hand
	print("position in organize:")
	print(global_position)
	var children = get_children()
	var card_count = children.size()
	#print_tree()
	if card_count == 0:
		return  # No cards to organize
	
	# Define boundaries for placement
	var start_x = -1200
	var end_x = 1600
	var y_position = 240  # Fixed y position for all cards
	
	# Calculate the total width occupied by cards with the given spacing
	var total_width = (card_count - 1) * 220
	
	# Adjust starting x to center cards within the defined bounds
	if total_width > (end_x - start_x):
		total_width = end_x - start_x  # Restrict total width to fit within bounds
	
	var center_offset = (end_x - start_x - total_width) / 2
	var current_x = start_x + center_offset  # Starting x position for the first card
	
	for i in range(card_count):
		var card = children[i]
		# Ensure the card is a Node2D (or compatible type)
		if card is Node2D:
			card.position = Vector2(current_x, y_position)
			current_x += 220  # Move to the next position
	print("position end organize")
	print(global_position)
