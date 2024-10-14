## Stores basic room preset data
##
## @author: Bennett Moore 2024
class_name PresetData
extends Resource




@export var preset_scene:PackedScene ## The preset scene
@export_flags("Enemies", "Loot", "Trapped", "Puzzle") var normal_flags = 0 ## General room characteristics
@export_flags("Start", "Red Shop", "Blue Shop", "Green Shop", "Boss") var special_flags = 0 ## Whether the preset room is special or not
@export_range(1,100,1) var x_len = 1 ## The width of the preset's floor (in tiles)
@export_range(1,100,1) var y_len = 1 ## The height of the preset's floor (in tiles)

func _init(_scene=null, _norms=0, _specs = 0, _x_len = 1, _y_len=1):
	preset_scene = _scene if _scene is PackedScene else load("res://dungeon_rooms/dungeon_layouts/floor_error.tscn")
	normal_flags = _norms
	special_flags = _specs
	x_len = _x_len
	y_len = _y_len
