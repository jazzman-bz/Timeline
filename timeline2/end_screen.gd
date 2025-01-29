extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_control_final_screen(score: Variant) -> void:
	
	
	
	var endmessage = self.get_node("EndMessage").text
	
	endmessage = "Congratulations! Your earned " + str(score) + " points!"
	
	
	
	pass # Replace with function body.
