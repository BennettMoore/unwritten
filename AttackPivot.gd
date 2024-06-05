extends Node2D

class_name AttackPivot
## Handles basic player attack functionality
##
## Acts as both a spawner, point of reference, and brain for all player attacks
## @author: Bennett Moore 2024

@export var attack_delay = 1.0 ## How long the player should have to wait before attacking again
@onready var parent: Player = get_parent()

## Sets the player's first weapon scene
func set_primary_attack(attack):
	PlayerData.primary_attack_scene = attack
	
## Sets the player's alternate weapon scene
func set_secondary_attack(attack):
	PlayerData.secondary_attack_scene = attack

## Allows skills to alter the player's base damage modifiers
func modify_damage_mods(flat_delta, mul_delta):
	PlayerData.damage_flat += flat_delta
	PlayerData.damage_mul += mul_delta

## Calculates the gross damage of a given attack
func calculate_attack(raw_damage, is_crit = false, is_super_crit = false):
	if is_super_crit:
		return PlayerData.crit_damage*2*(raw_damage*PlayerData.damage_mul) + PlayerData.damage_flat
	elif is_crit:
		return PlayerData.crit_damage*(raw_damage*PlayerData.damage_mul) + PlayerData.damage_flat
	else:	
		return (raw_damage*PlayerData.damage_mul) + PlayerData.damage_flat

## Chcks for critical hits
func is_crit():
	return PlayerData.crit_chance >= randf()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_pressed("attack") or Input.is_action_pressed("alt_attack")) and $AttackDelay.is_stopped():
		look_at(get_global_mouse_position())
		# Create a new instance of the Attack scene.
		var attack = PlayerData.primary_attack_scene.instantiate() if Input.is_action_pressed("attack") else PlayerData.secondary_attack_scene.instantiate()
		attack.position = Vector2(attack.offset, 0)
		attack.rotation = PI/2
		# Spawn the attack by adding it to the Main scene.
		add_child(attack)
		attack.is_crit = is_crit()
		$AttackDelay.start(attack.attack_delay)
