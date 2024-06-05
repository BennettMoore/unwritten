extends Control

class_name SkillTree
## Brain that controls all skill tree logic
##
## @author: Bennett Moore 2024

@onready var drop_points = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("DropPoints", "update")
	for point in drop_points:
		point.skills_changed.connect(_on_skills_changed)

func _on_skills_changed(in_tree, id, data):
	print("Skill at node #"+str(id)+" changed!")
