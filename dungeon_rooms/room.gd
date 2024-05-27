extends StaticBody2D

class_name Room
## Handles basic room functionality
##
## Stores which doors a room has, which are open, and allows the Dungeon Master to connect rooms together
## @author: Bennett Moore 2024

@export_flags("North", "East", "South", "West") var door_dirs = 0 ## Which doors the room has
enum {NORTH=1, EAST=2, SOUTH=4, WEST=8}
const COMPASS = {1:"North", 2:"East", 4:"South", 8:"West"}
@onready var open_doors = door_dirs

## Closes a specific door
func close_door(door:int):
	if open_doors&door:
		open_doors -= door
	else:
		print("Error! "+COMPASS[door]+" door already closed!")

## Closes a random valid door, or returns 0 if no door valid
func close_random_door():
	# No open doors
	if open_doors == 0:
		return 0
	# One open door, so no need for random choice
	elif open_doors == NORTH || open_doors == EAST || open_doors == SOUTH || open_doors == WEST:
		var closed_door = open_doors
		open_doors = 0
		return closed_door
	# Multiple open doors
	else:
		var door_options = []
		if open_doors&NORTH: door_options.append(NORTH)
		if open_doors&EAST: door_options.append(EAST)
		if open_doors&SOUTH: door_options.append(SOUTH)
		if open_doors&WEST: door_options.append(WEST)
		var random_door = door_options.pick_random()
		open_doors = open_doors&~random_door
		return random_door

## Whether a given door exists and is open
func has_door(door:int):
	return open_doors&door

## Returns how many doors are left
func has_open_doors():
	var doors_left = 0
	if open_doors&NORTH: doors_left += 1
	if open_doors&EAST: doors_left += 1
	if open_doors&SOUTH: doors_left += 1
	if open_doors&WEST: doors_left += 1
	
	return doors_left

## The global coordinates of a given door
func get_door_pos(door:int):
	if door_dirs&door:
		match(door):
			NORTH:
				return $NorthDoor.global_position
			EAST:
				return $EastDoor.global_position
			SOUTH:
				return $SouthDoor.global_position
			WEST:
				return $WestDoor.global_position
	# If door doesn't exist, or invalid number given, return null
	print("Error! Could not find door at direction: "+str(door)+"!")
	return null

## Moves the room to connect its door to a specific position
func connect_to(door:int, pos:Vector2):
	if !(door&door_dirs):
		print("Error! "+COMPASS[door]+" door invalid!")
		return false
	elif !(door & open_doors):
		print("Error! "+COMPASS[door]+" door already taken!")
		return false
	else:
		var door_dist = Vector2.ZERO
		match(door):
			NORTH:
				door_dist = $NorthDoor.global_position - global_position
			EAST:
				door_dist = $EastDoor.global_position - global_position
			SOUTH:
				door_dist = $SouthDoor.global_position - global_position
			WEST:
				door_dist = $WestDoor.global_position - global_position
			_:
				print("Error! Could not find door at direction: "+str(door)+"!")
				return false
		var new_position = Transform2D(0, (pos - door_dist)) # Aligns new position to door's origin instead of room's origin
		var valid_move = !test_move(new_position, Vector2.ZERO)
		if valid_move:
			global_position = (pos - door_dist)
			open_doors -= door
			return true
		else:
			return false
