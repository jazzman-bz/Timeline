extends Node2D

var cards = []  # This will store the card data as dictionaries.
var json_file_path = "res://images_metadata.json"  # Path to the JSON file
var card_count : int = 0

@onready var card_scene: PackedScene = preload("res://main.tscn")
#@onready var card = get_node("Card")
#@onready var card
@onready var spawn = $Spawn
############################
# Called when the node enters the scene tree for the first time.
func _ready():
	# Load and parse the JSON file
	if load_json_file():
		print("Cards loaded successfully:")
		#for card in cards:
		#print(cards[1])
	else:
		print("Failed to load cards.")

	for entry in cards:
			var description = entry.get("description", "Unknown")
			var year = entry.get("year", "Unknown")
			var imagepath = "res://images/" + description + " - " + year + ".jpg"
			var image = load(imagepath)
			#var card = Card.new
			var instance = card_scene.instantiate()
			$Card/Card_Image.texture = image


func load_json_file() -> bool:
	# Open the file for reading
	var file = FileAccess.open(json_file_path, FileAccess.ModeFlags.READ)
	if file == null:
		print("Failed to open JSON file:", json_file_path)
		return false

	# Read the file's content
	var json_text = file.get_buffer(file.get_length()).get_string_from_utf8()

	# Parse the JSON content
	var parse_result = JSON.parse_string(json_text)
	if parse_result.has("error") and parse_result["error"] != OK:
		print("Error parsing JSON:", parse_result["error_message"])
		return false

	# Assign the parsed data directly to cards
	if parse_result.has("result"):
		cards = parse_result["result"]
	else:
		cards = parse_result  # Directly assign the parsed data (expected to be an array)

	return true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
