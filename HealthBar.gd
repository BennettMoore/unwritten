extends ProgressBar
## The player's health bar
##
## @author: Bennett Moore 2024

func _ready():
	await %main_menu.start_game
	update()

func update():
	max_value = PlayerData.max_hp
	if PlayerData.hp > max_value:
		value = max_value
		PlayerData.hp = max_value
	else:
		value = PlayerData.hp
	
