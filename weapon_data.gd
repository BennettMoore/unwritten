extends Resource

class_name WeaponData

@export var weapon_scene: PackedScene
@export var weapon_icon: CompressedTexture2D
@export var weapon_name: String
@export var weapon_tags: Array[String]
@export_range(0.0, 200.0) var melee_scaling
@export_range(0.0, 200.0) var ranged_scaling
@export_range(0.0, 200.0) var magic_scaling

func _init(_scene=null, _icon=null, _name="N/A", _tags = []):
	weapon_scene = _scene if _scene is PackedScene else load("res://stab_attack.tscn")
	weapon_icon = _icon if _icon is CompressedTexture2D else load("res://art/sword_icon.png")
	weapon_name = _name
	weapon_tags = _tags
