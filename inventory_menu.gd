extends Menu
## The player's inventory menu
##
## Allows player to access their items, their skills, and the explored dungeon map
## @author: Bennett Moore 2024

## Called when the node enters the scene tree for the first time.
func _ready():
	hide()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if is_visible():
			close_menu()
		else:
			open_menu()

func _on_exit_button_pressed():
	close_menu()
