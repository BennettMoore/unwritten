## Node that contains the room's preset options
##
## @author: Bennett Moore 2024
class_name RoomMarker
extends Marker2D

@export_dir var preset_dir: Array[String] ## Where the preset data are stored
var presets: Array[PresetData] ## All possible preset options
@export_range(1,100,1) var x_len = 1 ## The width of the floor (in tiles) [NOT the walls]. Pick the max for non-square rooms
@export_range(1,100,1) var y_len = 1 ## The height of the floor (in tiles) [NOT the walls]. Pick the max for non-square rooms
# Called when the node enters the scene tree for the first time.
func _ready():
	if preset_dir != null and len(preset_dir) > 0:
		for dir in preset_dir:
			var file_paths = Global.get_all_res_paths(dir, "PresetData")
			for path in file_paths:
				presets.append(ResourceLoader.load(path, "PresetData"))
				if presets[-1].x_len > x_len or presets[-1].y_len > y_len:
					push_warning(name+" encountered a preset that was too big at index "+str(len(presets))+".\n\tRoom size: ["+x_len+", "+y_len+"]\n\tPreset size: ["+presets[-1].x_len+", "+presets[-1].y_len+"]")
				elif presets[-1].x_len == 1 and presets[-1].y_len == 1:
					push_warning(name+" encountered a preset with undefined size at index "+str(len(presets))+".")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Returns an array of indices based on what available presets meet the requirements
func has_trait(norm_flags = -1, spec_flags = -1):
	var options = []
	for p in range(presets.size()):
		if((norm_flags == -1 or presets[p].normal_flags == norm_flags) and (spec_flags == -1 or presets[p].special_flags == spec_flags)):
			options.append(p)
	return options
