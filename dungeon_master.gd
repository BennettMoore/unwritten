extends Node

var room_data = preload("res://room_data.gd")

enum {NORTH=1, EAST=2, SOUTH=4, WEST=8}
const COMPASS = {1:"North", 2:"East", 4:"South", 8:"West"}
const DOOR_MATCH = {1:4, 2:8, 4:1, 8:2}

@export var rooms: Array[RoomData]
@export var start_room: RoomData
@export var end_room: RoomData
@export var cap_rooms: Array[RoomData]

@onready var north_rooms: Array[RoomData] = rooms.filter(has_north)
@onready var east_rooms: Array[RoomData] = rooms.filter(has_east)
@onready var south_rooms: Array[RoomData] = rooms.filter(has_south)
@onready var west_rooms: Array[RoomData] = rooms.filter(has_west)

# Called when the node enters the scene tree for the first time.
func _ready():
	var start = start_room.room_scene.instantiate()
	add_child(start)
	start.global_position = Vector2.ZERO
	if !(start is Room):
		print("Error! Starting room is not a room!")
		pass
	var starting_door = start.close_random_door()
	if starting_door == 0:
		print("Error! Starting room has no doors!")
		pass
	else:
		print("Closed "+COMPASS[starting_door]+" door")
	
	room_placer(start, starting_door, 2)

func room_placer(old_room:Room, old_door:int, depth_limit:int):
	var next_room_data:RoomData
	
	if old_door == 0:
		print("No door found!")
		return
	
	match DOOR_MATCH[old_door]:
		NORTH:
			next_room_data = north_rooms.pick_random() if depth_limit > 0 else cap_rooms[0]
			print("North room found!")
		EAST:
			next_room_data = east_rooms.pick_random() if depth_limit > 0 else cap_rooms[1]
			print("East room found!")
		SOUTH:
			next_room_data = south_rooms.pick_random() if depth_limit > 0 else cap_rooms[2]
			print("South room found!")
		WEST:
			next_room_data = west_rooms.pick_random() if depth_limit > 0 else cap_rooms[3]
			print("West room found!")
		_:
			print("Error! "+str(DOOR_MATCH[old_door])+" invalid door direction")
			pass
	var next_room = next_room_data.room_scene.instantiate()
	add_child(next_room)
	next_room.connect_to(DOOR_MATCH[old_door], old_room.get_door_pos(old_door))
	if next_room.has_open_doors() and depth_limit > 0:
		for n in range(next_room.has_open_doors()):
			room_placer(next_room, next_room.close_random_door(), depth_limit-1)
	
func has_north(room:RoomData):
	return room.door_dirs & NORTH
func has_east(room:RoomData):
	return room.door_dirs & EAST
func has_south(room:RoomData):
	return room.door_dirs & SOUTH
func has_west(room:RoomData):
	return room.door_dirs & WEST

