extends PanelContainer

@export var stat_name = "Stat"
@export var num_val = 0
@export var icon = CompressedTexture2D
@onready var stat_name_node = $HSeparator/StatIcon/StatName
@onready var num_node = $HSeparator/StatNum
@onready var stat_icon_node = $HSeparator/StatIcon


# Called when the node enters the scene tree for the first time.
func _ready():
	stat_name_node.text = stat_name
	num_node.text = str(num_val)
	stat_icon_node.texture = icon
