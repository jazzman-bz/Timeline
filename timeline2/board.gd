extends Node2D

@export var card_spacing = 220


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
	var cards : Array[Card] = []

	for child in get_children():
		if child is Card:
			cards.append(child)

	var card_count = len(cards)

	var current_x = card_spacing * card_count * -0.5

	for card in cards:
		card.position = Vector2(current_x, 0)
		current_x += card_spacing  # Move to the next position


	print("position end organize")
	print(global_position)
