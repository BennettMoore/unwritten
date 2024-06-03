extends Panel

class_name DropPoint
## A drop point for a given skill
##
## Handles drag/drop logic and skill data transfer
## @author: Bennett Moore 2024

var _skill_data = preload("res://skill_data.gd")
var _skill = preload("res://skill.gd")


@export var held_data:SkillData ## The resource containing all skill data
@export var start_with_skill = false
@onready var held_skill = $Skill

# Called when the node enters the scene tree for the first time.
func _draw():
	held_skill.set_global_position(global_position)
	if start_with_skill:
		held_skill.visible = true
	elif held_data != null:
		add_skill()
	

func _can_drop_data(at_position, data):
	print("Asked to drop data!")
	return !held_skill.visible
	
func _drop_data(at_position, data):
	print("Data dropped!")
	held_data = data
	if held_skill != null:
		held_skill.visible = false
	add_skill()

func add_skill():
	print("Adding Skill...")
	if !held_skill.visible:
		held_skill.update(held_data)
		print("Added child!")
		held_skill.visible = true
		return true
	else:
		print("Error! A skill is already here!")
		return false
