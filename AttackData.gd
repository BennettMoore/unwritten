extends Resource

class_name AttackData

var damage: float
var knockback: float
var attackDir: float
var isTrueDamage: bool
var damageType: String
var isCrit: bool
var isSuperCrit: bool

func _init(iDamage = 0, iKnockback = 0, iIsTrueDamage = false, iDamageType = "None", iIsCrit = false, iIsSuperCrit = false):
	damage = iDamage
	knockback = iKnockback
	isTrueDamage = iIsTrueDamage
	damageType = iDamageType
	isCrit = iIsCrit
	isSuperCrit = iIsSuperCrit

