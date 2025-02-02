extends Node2D

var cards = []  # Store the card data
var json_file_path = "res://images_metadata.json"  # Path to the JSON file

@onready var card_scene: PackedScene = preload("res://card.tscn")
@onready var spawn = $Spawn  # Parent node where cards will be added
@onready var card_count_label = $CardCount/ColorRect/CardCount  # Reference to the CardCount label
@onready var hand = $Hand  # Parent node where cards in the hand will be added
@onready var board = $Board  # Parent node where cards in the hand will be added
@onready var graveyard_scene: PackedScene = preload("res://graveyard.tscn")
@onready var bronze_label = $BronzeStar/Bronzepoints
@onready var silver_label = $SilverStar/Silverpoints
@onready var gold_label = $GoldStar/Goldpoints
func _ready():
	
	var card_instances = []  # Store all card instances before adding them to spawn
	
	if load_json_file():
		print("Cards loaded successfully.")
	else:
		print("Failed to load cards.")
		return

	var x_offset = 0 # Adjust for spacing
	var y_offset = 0
	var cards_per_row = 5
	var card_index = 0

# all cards loaded - lets get their content
	for entry in cards:
		var description = entry.get("description", "Unknown")
		print(description)
		var year = entry.get("year", "Unknown")
		year = str(year)
		if year[0] == "-":  # Check if the first character is "-"
			year = year.substr(1) + "bc"  # Remove the first character and append " BC"
		var image_path = "res://images/" + description + " - " + str(year) + ".jpg"
		var image = load(image_path)

		# Create a new card instance
		var card_instance = card_scene.instantiate()

		card_instance.add_to_group("spawn_cards")

		# Configure the card instance - image, description and date
		var card_image_node = card_instance.get_node("Card_Image2")
		if card_image_node:
			card_image_node.texture = image

		var card_description_node = card_instance.get_node("Card_Template/Card_Description")
		if card_description_node:
			card_description_node.text = description

		var card_date_node = card_instance.get_node("Card_Template/Card_Date")
		if card_date_node:
			card_date_node.text = str(year)

		# Position the card - erst mal auf den Spawn Punkt.. etwas offset, damit ma sieht es sind viele
		#var row = card_index / cards_per_row
		#var col = card_index % cards_per_row
		#card_instance.position = Vector2(col * x_offset, row * y_offset)
#
		# Add the card to the spawn node
		card_instances.append(card_instance)
			# Pass the board's Area2D to the card
		var board_area = $Board/Area2D
		card_instance.set_board_area(board_area)

		card_index += 1
		
		# 🔄 SHUFFLE THE CARDS BEFORE ADDING THEM TO SPAWN
	card_instances.shuffle()

	# Add shuffled cards to spawn
	for card_instance in card_instances:
		spawn.add_child(card_instance)
		
	update_card_count()
	
	bronze_label.text = str(GameControl.bronzepoints)
	silver_label.text = str(GameControl.silverpoints)
	gold_label.text = str(GameControl.goldpoints)

func load_json_file() -> bool:
	var file = FileAccess.open(json_file_path, FileAccess.ModeFlags.READ)
	if file == null:
		print("Failed to open JSON file:", json_file_path)
		return false

	var json_text = file.get_buffer(file.get_length()).get_string_from_utf8()
	var parse_result = JSON.parse_string(json_text)
	if parse_result.has("error") and parse_result["error"] != OK:
		print("Error parsing JSON:", parse_result["error_message"])
		return false

	if parse_result.has("result"):
		cards = parse_result["result"]
	else:
		cards = parse_result
	return true


func _on_button_pressed() -> void:

	# ---- first deal hand
	var num_cards_to_move = 2
	var x_offset = 220  # Horizontal spacing between cards in the hand

	if spawn.get_child_count() < num_cards_to_move:
		print("Not enough cards in spawn to move!")
		return

	for i in range(num_cards_to_move):
		# Get the first card from the spawn
		var card_instance = spawn.get_child(0)
		# Move the card to the hand
		move_card_to_hand(card_instance)

	update_card_count()

	if spawn.get_child_count() < num_cards_to_move:
		print("Not enough cards in spawn to move!")
		return

	num_cards_to_move = 1
	for i in range(num_cards_to_move):
		# Get the first card from the spawn
		var card_instance = spawn.get_child(0)
		move_card_to_board(card_instance)

	update_card_count()
	$Button.visible = false
	


func move_card_to_hand(card_instance,):
	# Remove from spawn and add to hand
	card_instance.snapshot()
	spawn.remove_child(card_instance)
	hand.add_child(card_instance)

	# Add card to the "hand_cards" group
	card_instance.add_to_group("hand_cards")


func move_card_to_board(card_instance):
	# Remove from spawn and add to hand
	card_instance.snapshot()
	spawn.remove_child(card_instance)
	board.add_child(card_instance)


	# Add card to the "board cards" group
	card_instance.add_to_group("board_cards")

	for card in get_tree().get_nodes_in_group("board_cards"):
		var card_date = card.get_node("Card_Template/Card_Date")
		if card_date:
			card_date.visible = true

func update_card_count():
	# Set the text of the label to the current count of cards in Spawn
	card_count_label.text = str(spawn.get_child_count())
