extends Resource

class_name PresetData
## Stores basic room preset data
##
## @author: Bennett Moore 2024

@export var preset_scene:PackedScene ## The preset scene
@export_flags("Enemies", "Loot", "Trapped", "Puzzle") var normal_flags = 0 ## General room characteristics
@export_flags("Start", "Red Shop", "Blue Shop", "Green Shop", "Boss") var special_flags = 0 ## Whether the preset room is special or not

func _init(_scene=null, _norms=0, _specs = 0, _x_len = 1, _y_len=1):
	preset_scene = _scene if _scene is PackedScene else load("res://dungeon_rooms/dungeon_layouts/dungeon_presets/floor_error.tscn")
	normal_flags = _norms
	special_flags = _specs
