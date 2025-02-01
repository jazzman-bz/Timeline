extends Node2D

var cards = []  # Store the card data
var json_file_path = "res://images_metadata.json"  # Path to the JSON file

@onready var card_scene: PackedScene = preload("res://card.tscn")
#@onready var spawn = $Spawn  # Parent node where cards will be added
##@onready var card_count_label = $CardCount/ColorRect/CardCount  # Reference to the CardCount label
#@onready var hand = $Hand  # Parent node where cards in the hand will be added
#@onready var board = $Board  # Parent node where cards in the hand will be added
@onready var graveyard_scene: PackedScene = preload("res://graveyard.tscn")

var score:int

#signal final_screen(score)

var card_placement:bool

var player_turn: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_board_change_turn(last_card_correct: bool) -> void:

# war das die letzte karte und war sie korrekt
	var hand = get_parent().get_node("Hand")
	var graveyard = get_parent().get_node("Graveyard")
	if hand.get_child_count() == 0 and last_card_correct:
		print("gane end!") 
		var number_wrong_placed_cards = graveyard.get_child_count()
	# how many wrong in this round
		print (str(number_wrong_placed_cards) +" mistakes !")
		
		if number_wrong_placed_cards == 0:
			print("gold star")
			GameControl.score = 0
		elif number_wrong_placed_cards == 1:
			print("silver star")
			GameControl.score = 1
		elif number_wrong_placed_cards == 2: 
			print ("bronze star")
			GameControl.score = 2
		else:
			print ("wooden star")	
			GameControl.score = 3
		#emit_signal("final_screen", score)
		
		
		var main = get_parent()
		main.visible = false
		var final_scene = load("res://end_screen.tscn").instantiate()
		#final_scene.score = score  # Setzt den Score in der neuen Szene
	   # Wechsle zur neuen Szene
		get_tree().root.add_child(final_scene)  # Neue Szene als Kind von root hinzufügen
		#get_tree().current_scene.queue_free()  # Entferne die alte Szene
		
		
	if GameControl.player_turn == false:
		
		#in any case
		#insert_card_from_spawn()
		print ("last card correct:")
		print (last_card_correct)
		print (" Deal new card to board!")
		#func insert_card_from_spawn(): 
		# Hole die erste Karte vom Spawn

		var spawn_card = get_parent().get_node("Spawn").get_child(0)  
		if spawn_card == null:
			print("No cards in spawn!")
		#		return

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
			
		var board = get_parent().get_node("Board")
		var spawn = get_parent().get_node("Spawn")
		
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
			print("Deal Card to players hand")
			var spawn_card_2 = get_parent().get_node("Spawn").get_child(0)  
			if spawn_card_2 == null:
				print("No cards in spawn!")
			spawn_card_2.snapshot()
			spawn.remove_child(spawn_card_2)
			hand.add_child(spawn_card_2)
			GameControl.player_turn = true
		# Add card to the "hand_cards" group
			spawn_card_2.add_to_group("hand_cards")
			GameControl.player_turn = true
