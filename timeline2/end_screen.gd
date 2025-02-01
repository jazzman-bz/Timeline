extends Control

@onready var board = get_tree().get_root().get_node_or_null("Main/Board")
@onready var graveyard = get_tree().get_root().get_node_or_null("Main/Graveyard")
@onready var exile = get_tree().get_root().get_node_or_null("Main/Exile")
@onready var button = get_tree().get_root().get_node_or_null("Main/Button")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var endmessage = self.get_node("EndMessage")
	var localscore = GameControl.score
	endmessage.text = "Congratulations! Your earned " + str(localscore) + " points!"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_continue_pressed() -> void:
	
	get_tree().get_root().get_node("EndScreen").visible = false 
	get_tree().get_root().get_node("Main").visible = true  # Show Main scene again
	
	
	# Board and Grfaveyard to exile 
	move_all_to_exile()
	
	
	get_tree().change_scene_to_file("res://main.tscn")
	#get_parent().queue_free()  # Remove the EndScreen
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
	
func move_all_to_exile():
	
	for card in board.get_children():
		board.remove_child(card)
		exile.add_child(card)
		card.global_position = exile.global_position  # Move to Exile visually

	for card in graveyard.get_children():
		graveyard.remove_child(card)
		exile.add_child(card)
		card.global_position = exile.global_position  # Move to Exile visually
	button.visible = true
