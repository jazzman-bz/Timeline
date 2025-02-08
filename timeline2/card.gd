class_name Card
extends Node2D

@onready var anim_player = $AnimationPlayer  # Reference to the AnimationPlayer node
#@onready var raycast = $RayCast2D  # Reference to the RayCast2D
@onready var area2d = $Area2D
# Original position and scale
var original_position : Vector2
var original_scale : Vector2
var last_card

var is_being_dragged = false  # Tracks whether the card is being dragged
var is_on_board: bool = false  # Tracks if the card is on the board
var drag_offset = Vector2.ZERO # Offset to apply during dragging
var position_before_drag : Vector2

var board_area: Area2D  # Reference to the board's Area2D node

func _ready():
	original_position = global_position
	original_scale = scale
	var card_date = $Card_Template/Card_Date
	if card_date:
		card_date.visible = is_in_group("board_cards")

func _process(delta):
	if is_being_dragged:
		# Get the mouse position and update the card's global position
		global_position = get_viewport().get_mouse_position() +  drag_offset

# Handle mouse entering the area (hover effect)
func _on_area_2d_mouse_entered():
	print("entered")
	var current_position = position
	if is_in_group("hand_cards"):  # Only hover if the card is in the hand
		print("entered - hand")
		anim_player.play("hover_in")  # Play hover in animation


func _on_area_2d_mouse_exited():
	print("exit")
	var current_position = position
	if is_in_group("hand_cards"):  # Only hover if the card is in the hand
		print("exit-hand")
		anim_player.play("hover_out")
	if is_being_dragged:
		is_being_dragged = false  # Stop dragging if mouse leaves the card

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if is_in_group("hand_cards"):
		if event is InputEventMouseButton:
			  # Only hover if the card is in the hand
				if event.button_index == 1:
					if event.pressed:
						print("Mouse button pressed on card")
						z_index = 100
						is_being_dragged = true  # Start dragging
						#remove_from_group("hand_cards")  # Remove from "hand_cards" group
						position_before_drag = position
						print("Card removed from 'hand_cards' group")
						print ("global position:")
						print(global_position)
						print ("position:")
						print (position)
					else:
						print("Mouse button released on card")
						z_index = 0
						is_being_dragged = false  # Stop dragging
						if is_on_board:  # Check if the card is on the board
							place_card_on_board()
						else:
							return_to_original_position()

func return_to_original_position():
	print("Returning to original position")
	var tween = create_tween()
	tween.tween_property(
		self,
		"position",
		position_before_drag,
		0.5
	)

func snapshot() -> void:
	original_position = global_position
	last_card = self
	print("last_card:")
	print(last_card)

func go_to_position(local_position: Vector2) -> void:
	# We often call this after we had left the tree, so our position may be reset
	global_position = original_position

	printt("global:", global_position, "local:", position, "goal:", local_position)
	var tween = create_tween()

	tween.tween_property(
		self,
		"position",
		local_position,
		0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(snapshot)


func _on_board_area_entered(area):
	if area == self.area2d:
		print("Card entered board area")
		is_on_board = true  # Tracks if the card is on the board

func _on_board_area_exited(area):
	if area == self.area2d:
		print("Card exited board area")
		is_on_board = false

func set_board_area(area: Area2D):
	board_area = area
	if board_area:
		board_area.connect("area_entered", Callable(self, "_on_board_area_entered"))
		board_area.connect("area_exited", Callable(self, "_on_board_area_exited"))


func place_card_on_board():
	
	GameControl.player_turn = false	
	print("Turn:FALSE")
	print("Placing card on the board")

	snapshot()

	anim_player.play("hover_out")

	# Remove card from its current parent (if applicable)
	get_parent().remove_child(self)

	# Add card as a child of the board
	board_area.get_parent().add_child(self)

	# Update card position to current release position
	#global_position = get_viewport().get_mouse_position() + drag_offset

	# Update the group
	remove_from_group("hand_cards")
	add_to_group("board_cards")
	print("Card moved to 'board_cards' group and placed on the board")
	var card_date = self.get_node("Card_Template/Card_Date")
	if card_date:
		card_date.visible = true# Make Card_Date visible
		
	
