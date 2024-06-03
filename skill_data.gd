extends Resource

class_name SkillData
## Resource that contains all skill data
##
## @author: Bennett Moore 2024

@export var skill_icons: Array[CompressedTexture2D] ## The skill's possible icons
@export var skill_name: String ## The name of the skill
@export_range(0, 3) var skill_level: int ## What level the skill is (should always be within the bounts of skill_icons)
@export var is_active: bool ## Whether the skill is active or passive

func _init(_skill_icons, _skill_name = "N/A", _skill_level = 0, _is_active = false):
	skill_icons = _skill_icons
	skill_name = _skill_name
	skill_level = _skill_level
	is_active = _is_active
