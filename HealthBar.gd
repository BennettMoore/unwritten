extends ProgressBar
## The player's health bar
##
## @author: Bennett Moore 2024

func _ready():
	await %main_menu.start_game
	update()

func update():
	value = PlayerData.hp
