extends Resource

class_name RoomData

@export var room_scene:PackedScene
@export_flags("North", "East", "South", "West") var door_dirs = 0

func _init(_scene=null, _dirs = 0):
	room_scene = _scene if _scene is PackedScene else load("res://dungeon_rooms/dungeon_room_1.tscn")
	door_dirs = _dirs
