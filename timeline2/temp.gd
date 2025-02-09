extends Node


	var date_array = []
	for card in cards:
		var card_date_label = card.get_node("Card_Template/Card_Date")
		if card_date_label:
			date_array.append(card_date_label.text)  # Add the date to the array

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

			emit_signal("change_turn", last_card_correct)
			
	elif last_added_card.is_in_group("board_cards"):
		var card_marked_right = last_added_card.get_node("Right")
		card_marked_right.visible = true
		await get_tree().create_timer(2.0).timeout 
		print("The date array is sorted.")
		card_marked_right.visible = false
		await get_tree().create_timer(2.0).timeout 
		
		last_card_correct = true
		#GameControl.player_turn = false
		

		emit_signal("change_turn", last_card_correct)
