extends Node
## Holds all player data
##
## Persists between scenes, allowing player info to be preserved
## @author: Bennett Moore 2024

var speed = 300 ## How fast the entity will move (pixels/sec).
var max_hp = 100 ## The maximum health of the entity
var hp = 100 ## The current health of the entity
var armor = 0 ## The damage reduction value of the entity
var melee_damage = 10.0 ## The "melee damage" stat of the player
var magic_damage = 10.0 ## The "magic damage" stat of the player
var ranged_damage = 10.0 ## The "ranged damage" stat of the player
var crit_chance = 0.05 ## The percent chance of a critical hit occuring
var crit_damage = 2.0 ## The damage multiplier used when getting a crit
var primary_attack_scene: PackedScene = load("res://swing_attack.tscn") ## The player's first weapon scene
var secondary_attack_scene: PackedScene = load("res://stab_attack.tscn") ## The player's alternate weapon scene
var damage_flat = 0 ## The player's flat damage bonus 
var damage_mul = 1.0 ## The player's damage multiplier

## Returns player stats in order to properly render them in the inventory menu
func get_data(idx):
	match idx:
		0:
			return melee_damage
		1:
			return ranged_damage
		2:
			return magic_damage
		3:
			return armor
		4:
			return crit_chance
		5:
			return speed
		_:
			print("Error! "+str(idx)+" is not a real data index")
			return -1
