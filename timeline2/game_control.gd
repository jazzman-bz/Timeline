extends Node2D

var cards = []
var json_file_path = "res://images_metadata.json"  # Path to the JSON file

@onready var card_scene: PackedScene = preload("res://Scenes/card.tscn")
#@onready var spawn = $Spawn  # Parent node where cards will be added
##@onready var card_count_label = $CardCount/ColorRect/CardCount  # Reference to the CardCount label
#@onready var hand = $Hand  # Parent node where cards in the hand will be added
#@onready var board = $Board  # Parent node where cards in the hand will be added
@onready var graveyard_scene: PackedScene = preload("res://Scenes/graveyard.tscn")



var last_card_global
var score:int
var goldpoints:int
var silverpoints:int
var bronzepoints:int
var last_card_correct:bool
var card_placement:bool

var player_turn: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _card_placed_on_board(last_added_card) -> void:
	print("in signal placed on board #######################")
	#keine weiteren aktionen durch player momentan
	GameControl.player_turn = false
	var  board = get_node("/root/Main/Board")
	cards = board.get_children()
	# hole alle Karten und vergleiche deren Dates
	var date_array = []
	for card in cards:
		var card_date_label = card.get_node("Card_Template/Card_Date")
		if card_date_label:
			date_array.append(card_date_label.text)  # Add the date to the array
	print(date_array)
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
			#emit_signal("change_turn", last_card_correct)
			_on_board_change_turn(last_card_correct)
			
	elif last_added_card.is_in_group("board_cards"):
		var card_marked_right = last_added_card.get_node("Right")
		card_marked_right.visible = true
		await get_tree().create_timer(1.0).timeout 
		print("The date array is sorted.")
		card_marked_right.visible = false
		await get_tree().create_timer(1.0).timeout 
		
		last_card_correct = true
		#GameControl.player_turn = false
		#emit_signal("change_turn", last_card_correct)
		_on_board_change_turn(last_card_correct)
		
func get_graveyard() -> Node2D:
	return get_tree().root.get_node("Main/Graveyard")  # Adjust the path as needed
	
func is_sorted_date_array(date_array: Array) -> int:
	for i in range(date_array.size() - 1):
		if int(date_array[i]) > int(date_array[i + 1]): 
			print("********** now in compare ***************")
			print (date_array[i]) # Detect out-of-order date
			print (date_array[i + 1])
			return i #+ 1  # Return the index of the problematic card
	return -1  # If sorted, return -1

func _on_board_change_turn(last_card_correct: bool) -> void:

# war das die letzte karte und war sie korrekt
	var hand = get_parent().get_node("/root/Main/Hand")
	var graveyard = get_parent().get_node("/root/Main/Graveyard")
	
	# war die letzte Karte korrekt und war es Deine letzte aus der Hand
	if hand.get_child_count() == 0 and last_card_correct:
		print("gane end!") 
		var number_wrong_placed_cards = graveyard.get_child_count()
	# how many wrong in this round
		print (str(number_wrong_placed_cards) +" mistakes !")
		
		if number_wrong_placed_cards == 0:
			print("gold star")
			GameControl.score = 0
			GameControl.goldpoints +=1 
			var gold_label = get_parent().get_node("/root/Main/GoldStar/Goldpoints")
			gold_label.text = str(GameControl.goldpoints)
		elif number_wrong_placed_cards == 1:
			print("silver star")
			GameControl.score = 1
			GameControl.silverpoints +=1 
			var silver_label = get_parent().get_node("/root/Main/SilverStar/Silverpoints")
			silver_label.text = str(GameControl.silverpoints)
		elif number_wrong_placed_cards == 2: 
			print ("bronze star")
			GameControl.score = 2
			GameControl.bronzepoints +=1 
			var bronze_label = get_parent().get_node("/root/Main/BronzeStar/Bronzepoints")
			bronze_label.text = str(GameControl.bronzepoints)
		else:
			print ("wooden star")	
			GameControl.score = 3
		#emit_signal("final_screen", score)
		await get_tree().create_timer(2.0).timeout 
		print(GameControl.goldpoints)
		SceneManager.switch_to_endscreen()
			
		return
		# # Main-Szene ausblenden
		#var endscreen = preload("res://end_screen.tscn").instantiate()
		#get_tree().root.add_child(endscreen)  # Endscreen über Main-Szene anzeigen
		
		
	if GameControl.player_turn == false:
		#in any case
		#insert_card_from_spawn()
		print ("last card correct:")
		print (last_card_correct)
		print (" Deal new card to board!")
		#func insert_card_from_spawn(): 
		# Hole die erste Karte vom Spawn

		var spawn_card = get_parent().get_node("/root/Main/Spawn").get_child(0)  
		if spawn_card == null:
			print("No cards in spawn!")
			var  exile = get_node("/root/Main/Exile")
			var  spawn = get_node("/root/Main/Spawn")
			var cards_in_exile = exile.get_children()
			for card in cards_in_exile:
				exile.remove_child(card)
				spawn.add_child(card)
				card.add_to_group("spawn_cards")
			spawn_card = get_parent().get_node("/root/Main/Spawn").get_child(0)  
		#	#	return

		# Datum der Spawn-Karte direkt aus dem Label
		var spawn_date_label = spawn_card.get_node("Card_Template/Card_Date")  
		var spawn_description_label = spawn_card.get_node("Card_Template/Card_Description") 
		if not (spawn_date_label and spawn_date_label is Label):
			print("Spawn card does not have a valid date label!")
		#	return

		var spawn_date = int(spawn_date_label.text)  # Konvertiere das Datum in eine Zahl
		var spawn_description = spawn_description_label.text 
		print(spawn_date)
		print (spawn_description)
		# Alle Karten auf dem Board holen
			
		var board = get_parent().get_node("/root/Main/Board")
		var spawn = get_parent().get_node("/root/Main/Spawn")
		
			# Initiale X-Position
		# Retrieve all children of the board
		var children = board.get_children()
		
		# Get the date of the spawn card
		var spawn_card_date = spawn_card.get_node("Card_Template/Card_Date").text
		
		# Find the correct position
		var target_index = children.size()  # Default is to add at the end
		var position_last_card = Vector2()
		for i in range(children.size()):
			var child = children[i]
			position_last_card = child.global_position
			var child_date_label = child.get_node("Card_Template/Card_Date")
			if child_date_label:
				var child_date = child_date_label.text
				if spawn_card_date < child_date:
					target_index = i
					break
		#position letzte karte
		
		####### der Teil muss noch neu, weil momentan mit global position 
		var x_start_board = 1920/2 - (0.5*children.size()*220)
		
		GameControl.player_turn = true
		
		#wenn ganz nach links
		#if target_index == 1:
			#spawn_card.position = Vector2(x_start_board - 100, 0)
			#spawn_card.global_position = Vector2(x_start_board - 100, 519)
		#else:
			#spawn_card.position = Vector2(x_start_board - 100, 0)
			#spawn_card.global_position = Vector2(x_start_board + target_index*220, 519)
		#spawn_card.global_position = position_last_card + Vector2 (100,0)
		
		# Add and move the spawn card to the correct position
		
		#spawn_card.snapshot()
		#spawn.remove_child(spawn_card)
		#board.add_child(spawn_card)
		#spawn_date_label.visible = true 
		#GameControl.player_turn = true
		#spawn_card.add_to_group("board_cards")
		#board.move_child(spawn_card, target_index)
		

		if !last_card_correct:
			# last card was placed incorrect - so player gets a card in hand
			print("Deal Card to players hand")
			var spawn_card_2 = get_node("/root/Main/Spawn").get_child(0)  
			if spawn_card_2 == null:
				print("No cards in spawn!")
				var  exile = get_node("/root/Main/Exile")
				var cards_in_exile = exile.get_children()
				for card in cards_in_exile:
					exile.remove_child(card)
					spawn.add_child(card)
					spawn_card_2 = get_node("/root/Main/Spawn").get_child(0) 
					card.add_to_group("spawn_cards")
			spawn_card_2.snapshot()
			spawn.remove_child(spawn_card_2)
			hand.add_child(spawn_card_2)
			GameControl.player_turn = true
		# Add card to the "hand_cards" group
			spawn_card_2.add_to_group("hand_cards")
			var card_count_label = get_node("/root/Main/CardCount/ColorRect/CardCount")
			card_count_label.text = str(spawn.get_child_count())
			return
