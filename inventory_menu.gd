extends Menu


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if is_visible():
			close_menu()
		else:
			open_menu()

func _on_exit_button_pressed():
	close_menu()
