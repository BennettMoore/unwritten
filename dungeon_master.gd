extends Node
## Brain that handles all level generation
##
## Generates rooms, connects them together, and ensures all key rooms are placed within each level
## @author: Bennett Moore 2024

var room_data = preload("res://room_data.gd")

enum SPEC_FLAGS {END=1, GREEN=2, BLUE=4, RED=8} ## Each branch in the recursive loop may be given a special flag based on inheritance, passing it down to a random child until one fulfills their duty and places the special room
enum {NORTH=1, EAST=2, SOUTH=4, WEST=8}
const COMPASS = {1:"North", 2:"East", 4:"South", 8:"West"}
const DOOR_MATCH = {1:4, 2:8, 4:1, 8:2}

@export var rooms: Array[RoomData] ## All possible room options
@export var start_room: RoomData ## The starting room of the dungeon
@export var end_room: RoomData ## The ending room of the dungeon
@export var green_shop: RoomData ## The regular shop in each level
@export var blue_shop: RoomData ## The alternate shop in each level
@export var red_shop: RoomData ## The special shop/event in each level
@export var micro_cap_rooms: Array[RoomData] ## Emergency caps to use when there's no room for regular caps
@export_range(1, 10, 1, "or_greater") var dungeon_depth = 2 ## How far the dungeon should spread from the origin
@export_range(1,100,1) var spec_depth = 5 ## How deep the Dungeon Master should go to find space for a special room
@export_range(1,100,1) var placement_attempts = 15 ## How many times the Dungeon Master should try placing a room before giving up
@export_range(1,100,1) var meta_timeout_counter = 5 ## Prevents infinite loops in level generation
@export_flags("Boss Room", "Green Shop", "Blue Shop", "Red Shop") var starting_flags = 15 ## Since this is the root node, activate all special flags
var ending_flags = 0 ## Keeps track of rooms placed

@onready var north_rooms: Array[RoomData] = rooms.filter(has_north)
@onready var east_rooms: Array[RoomData] = rooms.filter(has_east)
@onready var south_rooms: Array[RoomData] = rooms.filter(has_south)
@onready var west_rooms: Array[RoomData] = rooms.filter(has_west)

## Called when the node enters the scene tree for the first time.
func _ready():
	var start = start_room.room_scene.instantiate()
	add_child(start)
	start.global_position = Vector2.ZERO
	if !(start is Room) or start.has_open_doors() == 0:
		print("Error! Starting room is not a real room!")
		pass
	var starting_door: int
	var room_rand = RandomNumberGenerator.new()
	var start_inheritance = plan_inheritance(start.has_open_doors(), starting_flags)
	for n in range(start.has_open_doors()):
		starting_door = start.close_random_door()
		print("Closed "+COMPASS[starting_door]+" door")
		print("Inheritance: "+flag_translator(start_inheritance[n]))
		room_placer(start, starting_door, dungeon_depth, spec_depth, room_rand, start_inheritance[n])
	# If not every special room was placed, try again
	if starting_flags != ending_flags:
		print("\tFailed ending flags: "+str(ending_flags))
		reset_level()

## Recursive function which places rooms according to a modified Depth-first Search algorithm
func room_placer(old_room:Room, old_door:int, depth_limit:int, spec_depth_limit: int, room_rand:RandomNumberGenerator, spec_flags = 0, failed_spec_placements = 0):
	var next_room_data:RoomData
	var next_room:Room
	var valid_move = false
	var timeout_counter = placement_attempts
	var spec_room_type = 0
	while !valid_move and timeout_counter > 0:
		timeout_counter -= 1
		if old_door == 0:
			print("Error! No door found!")
			return
		var which_spec_room = valid_spec_room(old_door,spec_flags)
		if which_spec_room != 0 and depth_limit <= end_room.min_depth and timeout_counter > placement_attempts/4:
			match which_spec_room:
				SPEC_FLAGS.END:
					next_room_data = end_room
					spec_room_type = SPEC_FLAGS.END
					print("End room found!")
				SPEC_FLAGS.GREEN:
					next_room_data = green_shop
					spec_room_type = SPEC_FLAGS.GREEN
					print("Green shop found!")
				SPEC_FLAGS.BLUE:
					next_room_data = blue_shop
					spec_room_type = SPEC_FLAGS.BLUE
					print("Blue shop found!")
				SPEC_FLAGS.RED:
					next_room_data = red_shop
					spec_room_type = SPEC_FLAGS.RED
					print("Red shop found!")
				_:
					push_warning("Error! "+str(which_spec_room)+" invalid special flag")
					pass
		else:
			if spec_flags != 0: 
				failed_spec_placements += 1
			match DOOR_MATCH[old_door]:
				NORTH:
					next_room_data = north_rooms.pick_random()
					print("North room found!")
				EAST:
					next_room_data = east_rooms.pick_random()
					print("East room found!")
				SOUTH:
					next_room_data = south_rooms.pick_random()
					print("South room found!")
				WEST:
					next_room_data = west_rooms.pick_random()
					print("West room found!")
				_:
					push_warning("Error! "+str(DOOR_MATCH[old_door])+" invalid door direction")
					pass
		next_room = next_room_data.room_scene.instantiate()
		add_child(next_room)
		ending_flags |= spec_room_type
		valid_move = next_room.connect_to(DOOR_MATCH[old_door], old_room.get_door_pos(old_door))
		if !valid_move:
			spec_room_type = 0
			remove_child(next_room)
			continue
		elif spec_flags != 0:
			spec_flags &= ~spec_room_type
			failed_spec_placements = 0
			print("Placed Special Room! Type: "+str(spec_room_type))
		
		if depth_limit > 0 or (spec_flags != 0 and spec_depth > 0):
			next_room.shuffle_doors(DOOR_MATCH[old_door])
		else:
			next_room.shuffle_doors(DOOR_MATCH[old_door], 1) # Turns room into a cap
	if timeout_counter <= 0:
		push_error("Error! room_placer timed out")
		print("ERRROR: room_placer timed out")
		next_room.connect_to(DOOR_MATCH[old_door], old_room.get_door_pos(old_door), true, true)
		match DOOR_MATCH[old_door]:
				NORTH:
					next_room_data = micro_cap_rooms[0]
					print("Emergency North cap used!")
				EAST:
					next_room_data = micro_cap_rooms[1]
					print("Emergency East cap used!")
				SOUTH:
					next_room_data = micro_cap_rooms[2]
					print("Emergency South cap used!")
				WEST:
					next_room_data = micro_cap_rooms[3]
					print("Emergency West cap used!")
				_:
					push_warning("Error! "+str(DOOR_MATCH[old_door])+" invalid door direction")
					pass
		next_room = next_room_data.room_scene.instantiate()
		add_child(next_room)
		next_room.connect_to(DOOR_MATCH[old_door], old_room.get_door_pos(old_door), true)
	elif next_room.has_open_doors():
		var next_inheritance = plan_inheritance(next_room.has_open_doors(), spec_flags)
		for n in range(next_room.has_open_doors()):
			room_placer(next_room, next_room.close_random_door(), depth_limit-1, spec_depth_limit-1, room_rand, next_inheritance[n], failed_spec_placements)
	
func has_north(room:RoomData):
	return room.door_dirs & NORTH
	
func has_east(room:RoomData):
	return room.door_dirs & EAST
	
func has_south(room:RoomData):
	return room.door_dirs & SOUTH
	
func has_west(room:RoomData):
	return room.door_dirs & WEST

## Internal function that translates special flags into human-readable strings
func flag_translator(spec_flags):
	var flag_names = ""
	if spec_flags&SPEC_FLAGS.END:
		flag_names+="End room, "
	if spec_flags&SPEC_FLAGS.GREEN:
		flag_names+="Green shop, "
	if spec_flags&SPEC_FLAGS.BLUE:
		flag_names+="Blue shop, "
	if spec_flags&SPEC_FLAGS.RED:
		flag_names+="Red shop, "
	return flag_names
	
## Plans how special flags will be inherited by the children of this room
func plan_inheritance(open_doors:int, spec_flags:int):
	if open_doors == 0: return []
	var inheritance_array: Array[int] = []
	inheritance_array.resize(open_doors)
	inheritance_array.fill(0)
	if spec_flags == 0:
		return inheritance_array
	
	var rand = RandomNumberGenerator.new()
	# Check each type of special flag
	if spec_flags & SPEC_FLAGS.END:
		inheritance_array[rand.randi_range(0, open_doors-1)] += SPEC_FLAGS.END
	if spec_flags & SPEC_FLAGS.GREEN:
		inheritance_array[rand.randi_range(0, open_doors-1)] += SPEC_FLAGS.GREEN
	if spec_flags & SPEC_FLAGS.BLUE:
		inheritance_array[rand.randi_range(0, open_doors-1)] += SPEC_FLAGS.BLUE
	if spec_flags & SPEC_FLAGS.RED:
		inheritance_array[rand.randi_range(0, open_doors-1)] += SPEC_FLAGS.RED
	
	return inheritance_array

## Checks whether or not an available special room can spawn, returning which type it is
func valid_spec_room(old_door:int, spec_flags:int):
	if spec_flags == 0:
		return 0
	elif spec_flags & SPEC_FLAGS.END and DOOR_MATCH[old_door] & end_room.door_dirs:
		return SPEC_FLAGS.END
	elif spec_flags & SPEC_FLAGS.GREEN and DOOR_MATCH[old_door] & green_shop.door_dirs:
		return SPEC_FLAGS.GREEN
	elif spec_flags & SPEC_FLAGS.BLUE and DOOR_MATCH[old_door] & blue_shop.door_dirs:
		return SPEC_FLAGS.BLUE
	elif spec_flags & SPEC_FLAGS.RED and DOOR_MATCH[old_door] & red_shop.door_dirs:
		return SPEC_FLAGS.RED
	else:
		return 0

## Resets the level generator
func reset_level():
	if meta_timeout_counter > 0:
		var current_rooms = get_children()
		for room in current_rooms:
			remove_child(room)
		ending_flags = 0
		meta_timeout_counter -= 1
		_ready()
	else:
		print("Error! Level generator timed out")
