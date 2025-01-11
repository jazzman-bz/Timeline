extends Node2D


# The spacing between cards in the hand
var card_spacing = 220

# Called when the node enters the scene tree for the first time.
func _ready():
	print_tree()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_child_entered_tree(node: Node):
	organize_cards()

func _on_child_exiting_tree(node: Node) -> void:
	organize_cards()
	
var is_reorganizing = false  # Flag to prevent recursive calls

func organize_cards():
	# Get all cards in the hand
	var children = get_children()
	var card_count = children.size()
	print_tree()
	if card_count == 0:
		return  # No cards to organize
	
	# Define boundaries for placement
	var start_x = 0
	var end_x = 800
	var y_position = -60  # Fixed y position for all cards
	
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
