extends Menu
## The game's pause menu
##
## Allows player to access options, exit to main menu, or simply keep the game pasued
## @author: Bennett Moore 2024

## Called when the node enters the scene tree for the first time.
func _ready():
	hide()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if is_visible():
			close_menu()
		else:
			open_menu()

## When the "Resume" button is pressed
func _on_resume_button_pressed():
	close_menu()

## When the "Exit to main menu" button is pressed
func _on_exit_button_pressed():
	$Panel/QuitConfirmation.visible = true

## When the "Options" button is pressed
func _on_option_button_pressed():
	pass # Replace with function body.

## When the player confirms that they want to quit
func _on_quit_confirmation_confirmed():
	print("Muahahahahahaha! You can't kill me! I'm INVINCIBLE!")

## When the player decides not to quit the game
func _on_quit_confirmation_canceled():
	pass # Replace with function body.
