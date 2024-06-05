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
const DOOR_MATCH = {1:4, 2:8, 4:1, 8:2}
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
func connect_to(door:int, pos:Vector2, ignore_collision = false, is_ghost = false):
	if !(door&door_dirs): # Room doesn't have this door
		print("Error! "+COMPASS[door]+" door invalid!")
		return false
	elif !is_ghost and (!(door & open_doors) or !(door & valid_doors)): # Door technically exists, but is unusable 
		print("Error! "+COMPASS[door]+" door already taken!")
		return false
	else:
		var door_dist = get_door_pos(door) + global_position
		var new_position = Transform2D(0, global_position + (pos - get_door_pos(door))) # Aligns new position to door's origin instead of room's origin
		var valid_move = !test_move(new_position, Vector2.ZERO, null, 0)
		if is_ghost:
			if !valid_move and Global.SHOW_GHOSTS:
				print("$$GHOST CONNECT_TO$$")
				print("\tglobal position = "+str(global_position))
				print("\t"+COMPASS[door]+" door pos (here) = "+str(get_door_pos(door)))
				print("\t"+COMPASS[DOOR_MATCH[door]]+" door pos (there) = "+str(pos))
				var ghost_node = spawn_ghost(new_position.get_origin(), door)
				print("\tFINAL "+COMPASS[door]+" door pos (here) = "+str(ghost_node.get_door_pos(door)))
				print("\tFINAL global position = "+str(ghost_node.global_position))
			return valid_move
		elif valid_move or ignore_collision:
			"""print("**CONNECT_TO**")
			print("\tglobal position = "+str(global_position))
			print("\t"+COMPASS[door]+" door pos (here) = "+str(get_door_pos(door)))
			print("\t"+COMPASS[DOOR_MATCH[door]]+" door pos (there) = "+str(pos))"""
			global_position = new_position.get_origin()
			"""print("\tFINAL "+COMPASS[door]+" door pos (here) = "+str(get_door_pos(door)))
			print("\tFINAL global position = "+str(global_position))"""
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
		var pos: Vector2
		var new_position: Transform2D
		var ghost_color = Color(0.5, 0.5, 0.5, 0.5)
		if door_dirs&DOOR_MATCH[door]:
			pos = get_door_pos(DOOR_MATCH[door])
		else:
			pos = $Centroid.global_position
		match(door):
			NORTH:
				new_position = Transform2D(0, (pos - $NorthDoor.global_position + global_position))
			EAST:
				new_position = Transform2D(0, (pos - $EastDoor.global_position + global_position))
			SOUTH:
				new_position = Transform2D(0, (pos - $SouthDoor.global_position + global_position))
			WEST:
				new_position = Transform2D(0, (pos - $WestDoor.global_position + global_position))
			_:
				print("Error! Could not find door at direction: "+str(door)+"!")
				return false
		# return !test_move(new_position, Vector2.ZERO, null, 0)
		#var test = !test_move(new_position, Vector2.ZERO, null, 0)
		var test = connect_to(DOOR_MATCH[door], get_door_pos(door), true, true)
		
		return test
	else:
		print("Error! Room does not have door in direction: "+str(door))
		return false

func spawn_ghost(pos:Vector2, door:int):
	if Global.SHOW_GHOSTS:
		var ghost_color = Color(0.5, 0.5, 0.5, 0.5)
		match(door):
			NORTH:
				ghost_color = Color(1, 0.5, 0.5, 0.5)
			EAST:
				ghost_color = Color(0.5, 0.5, 1, 0.5)
			SOUTH:
				ghost_color = Color(0.5, 1, 0.5, 0.5)
			WEST:
				ghost_color = Color(1, 1, 0.5, 0.5)
			_:
				print("Error! Could not find valid ghost color for direction: "+str(door)+"!")
		var ghost = duplicate()
		ghost.collision_layer = 4
		ghost.collision_mask = 4
		ghost.set_modulate(ghost_color)
		add_sibling(ghost)
		ghost.global_position = pos
		ghost.top_level = true
		var door_line = Line2D.new()
		door_line.add_point(ghost.get_door_pos(door))
		door_line.add_point(get_door_pos(DOOR_MATCH[door]))
		door_line.default_color = ghost_color
		door_line.top_level = true
		add_child(door_line)
		var raw_line = Line2D.new()
		raw_line.add_point(pos)
		raw_line.add_point(global_position)
		raw_line.default_color = Color(1, 1, 1, 0.3)
		raw_line.top_level = true
		raw_line.width = 2
		add_child(raw_line)
		print("Ghost placed")
		return ghost
