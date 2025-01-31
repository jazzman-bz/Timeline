extends Control



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
	
	get_tree().quit()
#
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
