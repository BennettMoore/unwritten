extends Player
## Placeholder Mage Class
##
## @author: Bennett Moore 2024

@export var primary_attack_scene: PackedScene = load("res://swing_attack.tscn") ## The mage's first weapon scene
@export var secondary_attack_scene: PackedScene = load("res://stab_attack.tscn") ## The mage's alternate weapon scene

## Sets the base stats and data for this character type
func setStats():
	PlayerData.armor = 5.0
	PlayerData.melee_damage = 5.0
	PlayerData.magic_damage = 20.0
	PlayerData.ranged_damage = 5.0
	PlayerData.speed = 500
	PlayerData.max_hp = 80
	PlayerData.hp = 80
	PlayerData.crit_chance = 0.05
	PlayerData.crit_damage = 2
	if primary_attack_scene is PackedScene: PlayerData.primary_attack_scene = primary_attack_scene
	if secondary_attack_scene is PackedScene: PlayerData.secondary_attack_scene = secondary_attack_scene
