extends Node2D


# The spacing between cards in the hand
@export var card_spacing = 220

# Called when the node enters the scene tree for the first time.
func _ready():
	print_tree()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var is_reorganizing = false  # Flag to prevent recursive calls

func organize_cards():
	# Get all cards in the hand
	print("position in organize:")
	print(global_position)
	var cards : Array[Card] = []

	for child in get_children():
		if child is Card:
			cards.append(child)

	var card_count = len(cards)

	var current_x = card_spacing * card_count * -0.5

	for card in cards:
		card.go_to_position(Vector2(current_x, 0))
		current_x += card_spacing  # Move to the next position


func _on_child_order_changed() -> void:
	organize_cards()
