extends StaticBody2D

class_name Room
## Handles basic room functionality
##
## Stores which doors a room has, which are open, and allows the Dungeon Master to connect rooms together
## @author: Bennett Moore 2024

@export_flags("North", "East", "South", "West") var door_dirs = 0 ## Which doors the room actually has
@export var single_use = false ## Whether or not this room uses TileMap Layers
enum {NORTH=1, EAST=2, SOUTH=4, WEST=8}
const COMPASS = {1:"North", 2:"East", 4:"South", 8:"West"} ## Converts flags to readable text
@onready var valid_doors = door_dirs ## Which doors currently exist in the room
@onready var open_doors = door_dirs ## What doors are currently "open", AKA are free to connect to
@onready var tile_map:TileMap = $TileMap

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

## Returns how many open doors are left
func has_open_doors():
	var doors_left = 0
	if open_doors&NORTH: doors_left += 1
	if open_doors&EAST: doors_left += 1
	if open_doors&SOUTH: doors_left += 1
	if open_doors&WEST: doors_left += 1
	
	return doors_left

## Returns how many doors are left, open or not
func has_doors():
	var doors_left = 0
	if valid_doors&NORTH: doors_left += 1
	if valid_doors&EAST: doors_left += 1
	if valid_doors&SOUTH: doors_left += 1
	if valid_doors&WEST: doors_left += 1
	
	return doors_left

## The global coordinates of a given door
func get_door_pos(door:int):
	if valid_doors&door:
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
func connect_to(door:int, pos:Vector2, ignore_collision = false):
	if !(door&door_dirs): # Room doesn't have this door
		print("Error! "+COMPASS[door]+" door invalid!")
		return false
	elif !(door & open_doors) or !(door & valid_doors): # Door technically exists, but is unusable 
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
		var valid_move = !test_move(new_position, Vector2.ZERO, null, 0)
		if valid_move or ignore_collision:
			global_position = (pos - door_dist)
			open_doors -= door
			return true
		else:
			return false

## Shuffles which doors the room has available
func shuffle_doors(req_doors: int, pref_door_count = -1):
	var walls = tile_map.get_layers_count() - 1 ## How many walls the room has access to
	var new_doors = 0
	var new_door_count = 0
	# Either there aren't any walls to enable/disable, the doors are locked, or no change is needed
	if walls < 1 or single_use or req_doors == valid_doors:
		return false
	
	var layer_indices = [-1, -1, -1, -1] ## Array that holds the NorthWall, EastWall, SouthWall, and WestWall indices respectively
	
	# First, find the layers that correspond to each wall
	for n in range(0, walls):
		if tile_map.get_layer_name(n) == "NorthWall":
			layer_indices[0] = n
		elif tile_map.get_layer_name(n) == "EastWall":
			layer_indices[1] = n
		elif tile_map.get_layer_name(n) == "SouthWall":
			layer_indices[2] = n
		elif tile_map.get_layer_name(n) == "WestWall":
			layer_indices[3] = n
		elif tile_map.get_layer_name(n) == "Base": # Found the base layer, so there won't be any layers past this
			print("Warning: shuffle_doors found base layer")
			break
		else:
			print("Error! \""+tile_map.get_layer_name(n)+"\" is not a valid tilemap layer name!")
	# Next, remove the walls corresponding to each required door
	if req_doors&NORTH and layer_indices[0] != -1:
		tile_map.set_layer_enabled(layer_indices[0], false)
		new_doors|=NORTH
		new_door_count+=1
	if req_doors&EAST and layer_indices[1] != -1:
		tile_map.set_layer_enabled(layer_indices[1], false)
		new_doors|=EAST
		new_door_count+=1
	if req_doors&SOUTH and layer_indices[2] != -1:
		tile_map.set_layer_enabled(layer_indices[2], false)
		new_doors|=SOUTH
		new_door_count+=1
	if req_doors&WEST and layer_indices[3] != -1:
		tile_map.set_layer_enabled(layer_indices[3], false)
		new_doors|=WEST
		new_door_count+=1
	
	# If you opened all doors asked for, set the new values and return true
	if pref_door_count != -1 and new_door_count >= pref_door_count:
		valid_doors = new_doors
		open_doors &= new_doors
		return true
	else:
		var door_counter = 0
		var rand = RandomNumberGenerator.new()
		if pref_door_count != -1:
			door_counter = pref_door_count - new_door_count
		else:
			door_counter = rand.randi_range(0, 4 - new_door_count)
		while(door_counter > 0):
			door_counter -= 1
			if layer_indices[0] != -1 and tile_map.is_layer_enabled(layer_indices[0]) and test_doorway(NORTH):
				tile_map.set_layer_enabled(layer_indices[0], false)
				new_doors|=NORTH
				new_door_count+=1
			elif layer_indices[1] != -1 and tile_map.is_layer_enabled(layer_indices[1]) and test_doorway(EAST):
				tile_map.set_layer_enabled(layer_indices[1], false)
				new_doors|=EAST
				new_door_count+=1
			elif layer_indices[2] != -1 and tile_map.is_layer_enabled(layer_indices[2]) and test_doorway(SOUTH):
				tile_map.set_layer_enabled(layer_indices[2], false)
				new_doors|=SOUTH
				new_door_count+=1
			elif layer_indices[3] != -1 and tile_map.is_layer_enabled(layer_indices[3]) and test_doorway(WEST):
				tile_map.set_layer_enabled(layer_indices[3], false)
				new_doors|=WEST
				new_door_count+=1
			else:
				break
		valid_doors = new_doors
		open_doors &= new_doors
		return true

## Decides whether a theoretical doorway has enough space near it to consider turning into a real door
func test_doorway(door:int):
	if door_dirs&door: # Ensure door exists and is not already in use
		var center_dist = $Centroid.global_position - global_position
		var new_position: Transform2D
		match(door):
			NORTH:
				new_position = Transform2D(0, ($NorthDoor.global_position - center_dist))
			EAST:
				new_position = Transform2D(0, ($EastDoor.global_position - center_dist))
			SOUTH:
				new_position = Transform2D(0, ($SouthDoor.global_position - center_dist))
			WEST:
				new_position = Transform2D(0, ($WestDoor.global_position - center_dist))
			_:
				print("Error! Could not find door at direction: "+str(door)+"!")
				return false
		return !test_move(new_position, Vector2.ZERO, null, 0)
	else:
		print("Error! Room does not have door in direction: "+str(door))
		return false
