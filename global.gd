extends Node
## Holds all generic global variables and functions
##
## @author: Bennett Moore 2024

## All possible damage types
enum DAMAGE_TYPES {NONE, BLUDGEONING, PIERCING, SLASHING, FIRE, EARTH, WATER, LIGHTNING, ARCANE, TRUE}
const SHOW_GHOSTS = false ## Whether "ghost" rooms (AKA invalid room placements) should be visible to the player

var drop_points: Dictionary ## Holds all drop point data, keyed by the node's hashed path data

## Finds and returns all file paths in a given directory
func get_all_file_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += get_all_file_paths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths

## Finds and returns all resource paths in a given directory
func get_all_res_paths(path: String, hint: String = "") -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += get_all_file_paths(file_path)  
		elif ResourceLoader.exists(file_path, hint):
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths
