extends Control

@onready var board = get_tree().get_root().get_node_or_null("/root/Main/Board")
@onready var graveyard = get_tree().get_root().get_node_or_null("/root/Main/Graveyard")
@onready var exile = get_tree().get_root().get_node_or_null("/root/Main/Exile")
@onready var button = get_tree().get_root().get_node_or_null("/root/Main/Button")


# Called when the node enters the scene tree for the first time.

# Es enstehen multiple instanzen - ich weiss noch nicht warum

func _ready() -> void:
	
	add_to_group("scenes")
	

	# Statische Variable, um doppelte Instanzen zu verhindern
	#if instance_exists:
		#queue_free()  # Falls es schon eine Instanz gibt, beende diese sofort
		#return

	#instance_exists = true  # Erste Instanz markieren
	
	var endmessage = self.get_node("EndMessage")
	var localscore = GameControl.score
	var localtext: String
	
	if localscore == 0:
		localtext = "a GOLD Star!"
		
	if localscore == 1:
		localtext = "a SILVER Star"
		
	if localscore == 2:
		localtext = "a BRONZE Star!"
		
	#else :
		#localtext = "NO STAR this time"
	endmessage.text = "Congratulations! Your earned " + localtext
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_continue_pressed() -> void:
	
	#get_tree().get_root().get_node("EndScreen").visible = false 
	#get_tree().get_root().get_node("Main").visible = true  # Show Main scene again
	#get_tree().current_scene.hide() 
	
	# Board and Graveyard to exile 
	
	get_tree().current_scene.hide() 
	#get_tree().current_scene.queue_free()

	
	SceneManager.return_to_main()

#get_tree().change_scene_to_file("res://main.tscn")
	#get_parent().queue_free()  # Remove the EndScreen
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
	
