extends Node

var main_scene = null  # Speichert die Referenz zur Main-Szene
var end_screen = null  # Speichert die Referenz zur End-Szene
@onready var button = get_tree().get_root().get_node_or_null("/root/Main/Button")


func switch_to_endscreen():
	if main_scene:
		get_tree().root.remove_child(main_scene) 
		#main_scene.hide()  # Main-Szene ausblenden, aber nicht löschen
		
		
	end_screen = preload("res://end_screen.tscn").instantiate()
	get_tree().root.add_child(end_screen)  # End-Szene als neues UI
	get_tree().current_scene = end_screen  # End-Szene als aktive Scene setzen
	
func return_to_main():
	
	# multiple instanzen killen
	#for scene in get_tree().get_nodes_in_group("scenes"):
		#scene.queue_free()
	
	if end_screen:
		end_screen.queue_free()  # End-Szene löschen
		end_screen.hide()
		end_screen = null  # Referenz zurücksetzen
		#if main_scene.has_node("Board"):
			#main_scene.get_node("Board").queue_free()
	get_tree().root.add_child(main_scene)  # End-Szene als neues UI
	get_tree().current_scene = main_scene  # End-Szene als aktive Scene setzen
	
	var board = get_node("/root/Main/Board")
	var exile = get_node("/root/Main/Exile")
	var graveyard = get_node("/root/Main/Graveyard")
	
	var board_cards = board.get_children()
	for card in board_cards:
		if card is Card:  
			board.remove_child(card)
		#board.remove_child(card)
			exile.add_child(card)
			card.global_position = exile.global_position  # Move to Exile visually
	
	var graveyard_cards = graveyard.get_children()
	for card in graveyard_cards:
		if card is Card:  
			graveyard.remove_child(card)
		#board.remove_child(card)
			exile.add_child(card)
			card.global_position = exile.global_position  # Move to Exile visually
	
	var button = get_node("/root/Main/Button")
	button.visible = true
	#if main_scene:
		#if main_scene.has_node("Board"):
			#main_scene.get_node("Board").queue_free()
	
	#get_tree().root.get_node("Main/EndScreen").queue_free()

			
	#var board_scene = preload("res://board.tscn")
	#var new_board = board_scene.instantiate()
	
	#await get_tree().create_timer(2.0).timeout 
	
	#main_scene.add_child(new_board)
	
	#new_board.name = "Board"  # Wichtig, falls Code nach 'Board' sucht
	#main_scene.show()  # Main-Szene wieder sichtbar machen
	get_tree().current_scene = main_scene  # Main-Szene als aktive Scene setzen
	
		
