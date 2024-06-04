extends Resource

class_name RoomData
## Stores basic room data
##
## @author: Bennett Moore 2024

@export var room_scene:PackedScene ## The room scene
@export_flags("North", "East", "South", "West") var door_dirs = 0 ## Which doors the room has
@export var min_depth = 0 ## The minimum depth the room should appear in (only applies to essential rooms)

func _init(_scene=null, _dirs = 0, _min_depth = 0):
	room_scene = _scene if _scene is PackedScene else load("res://dungeon_rooms/dungeon_room_1.tscn")
	door_dirs = _dirs
	min_depth = _min_depth
