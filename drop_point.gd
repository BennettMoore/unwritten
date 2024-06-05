extends TextureRect

class_name DropPoint
## A drop point for a given skill
##
## Handles drag/drop logic and skill data transfer
## @author: Bennett Moore 2024

signal skills_changed(in_tree:bool, id:int, data:SkillData)

var _skill_data = preload("res://skill_data.gd")

@export var empty_texture:CompressedTexture2D = load("res://icon.svg") ## The default texture to show when no skill is socketed
@export var held_data:SkillData ## The resource containing all skill data
@export var has_skill = false ## Whether the skill in this drop point is valid or not
@export var in_tree = true ## Whether this drop point is in the actual skill tree or not
@export_range(-1, 100, 1) var id = -1 ## The unique ID of this node in the tree, or -1 if not in tree
@export var children:Array[DropPoint] ## This node's children
var parents:Array[DropPoint]
var lines:Dictionary = {}

func _ready():
	# Find all your children and tell them who their parent(s) are
	if children != null and !children.is_empty():
		for child in children:
			child.parents.append(self)
	
	# TODO Remove this code and get skills functioning correctly
	if held_data == null and has_skill:
		print("Found null data!")
		held_data = SkillData.new(
			[load("res://art/skill_duck_1.png"), load("res://art/skill_duck_2.png"), load("res://art/skill_duck_3.png"), load("res://art/skill_duck_4.png")],
			"Test",
			min(id+1, 3),
			false,
			"This is a tooltip!"
		)
		texture = held_data.skill_icons[held_data.skill_level]
	elif has_skill:
		print("Added Skill \""+held_data.skill_name+"\"!")
		texture = held_data.skill_icons[held_data.skill_level]
		has_skill = true
	Global.drop_points[get_uuid()] = held_data

## Called whenever the drop point is drawn on the screen
func _draw():
	if children != null and !children.is_empty():
		for child in children:
			if lines.has(child.id):
				lines[child.id].set_point_position(0, global_position + Vector2(size.x/2, size.y/2))
				lines[child.id].set_point_position(1, child.global_position + Vector2(child.size.x/2, child.size.y/2))
			else:
				var line = Line2D.new()
				line.add_point(global_position + Vector2(size.x/2, size.y/2))
				line.add_point(child.global_position + Vector2(child.size.x/2, child.size.y/2))
				line.top_level = true
				add_child(line)
				lines[child.id] = line
			if !has_skill or held_data.skill_level <= 0:
				lines[child.id].set_modulate(Color(0.7, 0.7, 0.7, 1))
			else:
				lines[child.id].set_modulate(Color(1, 1, 1, 1))
	set_icon()

## Called when data is dragged from this node
func _get_drag_data(at_position):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.set_modulate(Color(0.7, 0.7, 0.7, 0.9))
	preview_texture.set_size(size)
	preview_texture.z_index = 10
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	var dragged_data = held_data
	held_data = null
	has_skill = false
	texture = empty_texture
	skills_changed.emit(in_tree, id, held_data)
	Global.drop_points[get_uuid()] = null
	return dragged_data

## Called to determine whether this node can have data dropped into it
func _can_drop_data(at_position, data):
	return !has_skill

## Called when data is dropped into this node
func _drop_data(at_position, data):
	print("Data dropped!")
	held_data = data
	has_skill = true
	set_icon()
	skills_changed.emit(in_tree, id, held_data)
	Global.drop_points[get_uuid()] = held_data

## Sets the correct texture for this skill node
func set_icon():
	if held_data == null or held_data.skill_level > held_data.skill_icons.size():
		if held_data != null: push_error("Error! Skill \""+held_data.skill_name+"\" does not have a valid icon at level "+str(held_data.skill_level))
		texture = empty_texture
		has_skill = false
	else:
		texture = held_data.skill_icons[held_data.skill_level]
		has_skill = true

## Manually updates the drop point's data
func update():
	if Global.drop_points.has(get_uuid()):
		held_data = Global.drop_points[get_uuid()]
	else:
		held_data = null
	set_icon()

## Retrieve the unique identifier for this drop point
func get_uuid():
	return get_path().hash()
