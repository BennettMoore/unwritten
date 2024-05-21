extends Resource

class_name AttackData
## Resource that contains all attack data
##
## @author: Bennett Moore 2024

var damage: float ## The daamge being dealt
var knockback: float ## How far the attack should knock the target back
var damage_type: Global.DAMAGE_TYPES ## The damage type of the attack
var is_crit: bool ## Whether the attack was a critical hit or not
var is_super_crit: bool ## Whether the attack was a Super crit

func _init(iDamage = 0, iKnockback = 0, i_damage_type = Global.DAMAGE_TYPES.NONE, i_is_crit = false, i_is_super_crit = false):
	damage = iDamage
	knockback = iKnockback
	damage_type = i_damage_type
	is_crit = i_is_crit
	is_super_crit = i_is_super_crit

