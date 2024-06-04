extends TextureRect

class_name DropPoint
## A drop point for a given skill
##
## Handles drag/drop logic and skill data transfer
## @author: Bennett Moore 2024

var _skill_data = preload("res://skill_data.gd")

@export var empty_texture:CompressedTexture2D = load("res://icon.svg") ## The default texture to show when no skill is socketed
@export var held_data:SkillData ## The resource containing all skill data
@export var has_skill = false ## Whether the skill in this drop point is valid or not
func _ready():
	if held_data == null and has_skill:
		print("Found null data!")
		held_data = SkillData.new([load("res://art/skill_empty_1.png"), load("res://art/skill_empty_2.png"), load("res://art/skill_empty_3.png"), load("res://art/skill_empty_4.png")], "Test", 0)
		texture = load("res://art/skill_empty_1.png")
	elif has_skill:
		print("Added Skill \""+held_data.skill_name+"\"!")
		texture = held_data.skill_icons[held_data.skill_level]
		has_skill = true
	
func _draw():
	set_icon()

func _get_drag_data(at_position):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.set_modulate(Color(1, 1, 1, 0.5))
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	var dragged_data = held_data
	held_data = null
	has_skill = false
	texture = empty_texture
	return dragged_data

func _can_drop_data(at_position, data):
	return !has_skill
	
func _drop_data(at_position, data):
	print("Data dropped!")
	held_data = data
	has_skill = true
	set_icon()

func set_icon():
	if held_data == null or held_data.skill_level > held_data.skill_icons.size():
		if held_data != null: push_error("Error! Skill \""+held_data.skill_name+"\" does not have a valid icon at level "+str(held_data.skill_level))
		texture = empty_texture
		has_skill = false
	else:
		texture = held_data.skill_icons[held_data.skill_level]
		has_skill = true
