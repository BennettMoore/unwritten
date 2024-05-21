extends Player


## Sets the base stats and data for this character type
func setStats():
	PlayerData.armor = 20.0
	PlayerData.melee_damage = 20.0
	PlayerData.magic_damage = 5.0
	PlayerData.ranged_damage = 5.0
	PlayerData.speed = 300
	PlayerData.max_hp = 150
	PlayerData.hp = 150
