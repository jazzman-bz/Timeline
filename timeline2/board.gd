extends Node2D

@export var card_spacing = 220

@onready var hand = $Hand  # Parent node where cards in the hand will be added
@onready var board = $Board  # Parent node where cards in the hand will be added
@onready var graveyard = $Graveyard  # Parent node where cards in the hand will be added

var last_card_correct: bool
signal change_turn(last_card_correct:bool)
signal card_placed_on_board(last_added_card)
var cards : Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_turn.connect(get_node("/root/GameControl")._on_board_change_turn)
	card_placed_on_board.connect(get_node("/root/GameControl")._card_placed_on_board)
	child_entered_tree.connect(get_node("/root/Main/Board")._on_child_entered_tree)
	child_order_changed.connect(get_node("/root/Main/Board").organize_cards)
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
	
	cards.clear()

	for child in get_children():
		if child is Card:
			cards.append(child)

	# Order cards by their actual (current) world positions
	cards.sort_custom(position_comparator)

	# Layout cards in user-determined order
	var card_count = len(cards)

	var current_x = card_spacing * card_count * -0.5
	var temp_index :int =0 
	var final_index :int =0
	for card in cards:
		# an der richtigen stelle als child einsortieren dazu muss ich wissen welcher index
		if card == GameControl.last_card_global:
			final_index = temp_index
		card.go_to_position(Vector2(current_x, 0))
		temp_index += 1
		current_x += card_spacing  # Move to the next position
	# all cards on board 
	# now evaluation
	print("last added card:")
	print(last_added_card)
	print(GameControl.last_card_global)
	print("Position:"+str(final_index))
	
	#damit es keine rekursion gibt
	child_order_changed.disconnect(get_node("/root/Main/Board").organize_cards)
	
	self.move_child(last_added_card, final_index)  # Move the child to the right position
	child_order_changed.connect(get_node("/root/Main/Board").organize_cards)
	
	# wait 2 seconds
	#await get_tree().create_timer(2.0).timeout 
	
	#emit_signal("card_placed_on_board", last_added_card)
	


	
func position_comparator(a : Card, b: Card) -> bool:
	return a.original_position.x < b.original_position.x



	
