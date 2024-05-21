extends Node

var character_data = preload("res://character_data.gd")

@export var mob_scene: PackedScene
@export var player_scenes: Array[CharacterData]
@onready var player = player_scenes[0].character_scene.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("menu"):
		get_tree().paused = true

func new_game():
	$Player.start($StartPosition.position)

func get_character_data():
	return player_scenes

func _on_main_menu_start_game(player_class):
	print(player_class)
	if 0 <= player_class && player_class < player_scenes.size(): # No out-of-bounds class selection
		player = player_scenes[player_class].character_scene.instantiate()
	else:
		print("Error! "+player_class+" is not a valid class ID!")
	add_child(player)
	new_game()