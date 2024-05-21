extends Menu

signal start_game(player_class)

var character_data = preload("res://character_data.gd")

@onready var itemList = $MenuContainer/MenuSplitter/CharacterSelect/ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	var character_array:Array[CharacterData] = get_parent().get_character_data()
	if !(character_array is Array[CharacterData]):
		print("Error! Character data invalid!")
	else:
		for character in character_array:
			itemList.add_item(character.select_name, character.select_icon)
	open_menu()

func _on_start_button_pressed():
	if itemList.is_anything_selected():
		var idx = itemList.get_selected_items()[0]
		start_game.emit(idx)
		close_menu()
	else:
		print("Please select a character")
