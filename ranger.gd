extends Player


## Sets the base stats and data for this character type
func setStats():
	PlayerData.armor = 10.0
	PlayerData.melee_damage = 5.0
	PlayerData.magic_damage = 5.0
	PlayerData.ranged_damage = 20.0
	PlayerData.speed = 450
	PlayerData.max_hp = 100
	PlayerData.hp = 100
