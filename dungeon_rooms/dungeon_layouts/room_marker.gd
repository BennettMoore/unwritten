extends Marker2D

class_name RoomMarker
## Node that contains the room's preset options
##
## @author: Bennett Moore 2024

@export var presets: Array[PresetData] ## All possible preset options
@export_range(1,100,1) var x_len = 1 ## The width of the floor (in tiles) [NOT the walls]
@export_range(1,100,1) var y_len = 1 ## The height of the floor (in tiles) [NOT the walls]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
