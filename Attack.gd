extends Area2D
## The abstract class of all attacks
##
## Applies to melee, ranged, and magical attacks
## @author: Bennett Moore 2024

@export var crit_effect: PackedScene = load("res://crit_effect.tscn") ## The "Crit!" visual effect object
@export var damage = 20 ## The base damage of the attack
@export var offset = 100 ## How far away the attack should be from the player upon spawning in pixels
@export var knockback = 200 ## How far away the attack should knock the target back
@export var attack_delay = 1.0 ## How long until the player can attack again
@export var damage_type: Global.DAMAGE_TYPES = Global.DAMAGE_TYPES.NONE ## The damage type of the attack
@export var is_crit = false ## Whether or not the given attack is a crit (Should *always* be false by default)
@onready var parent: AttackPivot = get_parent()

func _on_lifetime_timeout():
	queue_free()

func _on_body_entered(body):
	if is_crit:
		var crit_text = crit_effect.instantiate()
		add_child(crit_text)
		crit_text.global_rotation = 0
	if body.is_enemy:
		var data = AttackData.new(parent.calculate_attack(damage, is_crit), knockback, damage_type)
		body.onHit(data, parent.global_position)
		print(body.hp)
