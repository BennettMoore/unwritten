extends Resource

class_name WeaponData
## Resource that contains all weapon data
##
## @author: Bennett Moore 2024

@export var weapon_scene: PackedScene ## The weapon's scene
@export var weapon_icon: CompressedTexture2D ## The weapon's UI icon
@export var weapon_name: String ## The weapon's name
@export var weapon_tags: Array[String] ## Any tags associated with the weapon
@export_range(0.0, 200.0) var melee_scaling ## How effectively the weapon scales with the melee stat
@export_range(0.0, 200.0) var ranged_scaling ## How effectively the weapon scales with the ranged stat
@export_range(0.0, 200.0) var magic_scaling ## How effectively the weapon scales with the magic stat

func _init(_scene=null, _icon=null, _name="N/A", _tags = []):
	weapon_scene = _scene if _scene is PackedScene else load("res://stab_attack.tscn")
	weapon_icon = _icon if _icon is CompressedTexture2D else load("res://art/sword_icon.png")
	weapon_name = _name
	weapon_tags = _tags
