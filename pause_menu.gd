extends Menu


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if is_visible():
			close_menu()
		else:
			open_menu()


func _on_resume_button_pressed():
	close_menu()

func _on_exit_button_pressed():
	$Panel/QuitConfirmation.visible = true


func _on_option_button_pressed():
	pass # Replace with function body.


func _on_quit_confirmation_confirmed():
	print("Muahahahahahaha! You can't kill me! I'm INVINCIBLE!")


func _on_quit_confirmation_canceled():
	pass # Replace with function body.
