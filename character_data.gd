## Resource that contains all character data
##
## @author: Bennett Moore 2024
class_name CharacterData
extends Resource


@export var character_scene: PackedScene ## The character's scene
@export var select_icon: CompressedTexture2D ## The icon that should be displayed on the main menu
@export var select_name: String ## The name of the character

func _init(_scene=null, _icon=null, _name="N/A"):
	character_scene = _scene if _scene is PackedScene else load("res://player.tscn")
	select_icon = _icon if _icon is CompressedTexture2D else load("res://art/sword_icon.png")
	select_name = _name
