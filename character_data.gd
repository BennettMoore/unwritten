extends Resource

class_name CharacterData

@export var character_scene: PackedScene
@export var select_icon: CompressedTexture2D
@export var select_name: String

func _init(_scene=null, _icon=null, _name="N/A"):
	character_scene = _scene if _scene is PackedScene else load("res://player.tscn")
	select_icon = _icon if _icon is CompressedTexture2D else load("res://art/sword_icon.png")
	select_name = _name
