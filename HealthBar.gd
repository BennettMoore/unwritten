extends ProgressBar

var player = null

func _ready():
	await %main_menu.start_game
	update()

func update():
	if player == null:
		player = get_node("Player")
	if player != null: # If player is still null, skip
		value = player.hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
