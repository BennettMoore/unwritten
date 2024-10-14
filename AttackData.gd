## Resource that contains all attack data
##
## @author: Bennett Moore 2024
class_name AttackData
extends Resource

var damage: float ## The damage being dealt
var knockback: float ## How far the attack should knock the target back
var damage_type: Global.DAMAGE_TYPES ## The damage type of the attack
var is_crit: bool ## Whether the attack was a critical hit or not
var is_super_crit: bool ## Whether the attack was a Super crit

func _init(_damage = 0, _knockback = 0, _damage_type = Global.DAMAGE_TYPES.NONE, _is_crit = false, _is_super_crit = false):
	damage = _damage
	knockback = _knockback
	damage_type = _damage_type
	is_crit = _is_crit
	is_super_crit = _is_super_crit
