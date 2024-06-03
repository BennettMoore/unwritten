extends TextureRect

class_name Skill
## The abstract class for all skills
##
## Handles all boilerplate found across all skill types
## @author: Bennett Moore 2024

var skill_data = preload("res://skill_data.gd")

@export var data:SkillData ## The resource containing all skill data

## Called when the node enters the scene tree for the first time.
func _ready():
	if data == null or data.skill_level > data.skill_icons.size():
		if data != null: push_error("Error! Skill \""+data.skill_name+"\" does not have a valid icon at level "+str(data.skill_level))
		else: push_error("Error! Skill data not found!")
		texture = load("res://art/skill_empty_1.png")
	else:
		texture = data.skill_icons[data.skill_level]

## Called when dragging a skill to a drop point
func _get_drag_data(at_position) -> SkillData:
	print("Got drag data!")
	set_drag_preview(self)
	return data

func update(new_data:SkillData):
	data = new_data
	texture = new_data.skill_icons[new_data.skill_level]
