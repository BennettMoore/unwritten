extends Node2D

class_name AttackPivot

@export var primary_attack_scene: PackedScene
@export var secondary_attack_scene: PackedScene
@export var attack_delay = 1.0
@export var damage_flat = 0
@export var damage_mul = 1.0
@onready var parent: Player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_primary_attack(attack):
	primary_attack_scene = attack
	
func set_secondary_attack(attack):
	secondary_attack_scene = attack

func modify_damage_mods(flat_delta, mul_delta):
	damage_flat += flat_delta
	damage_mul += mul_delta

func calculate_attack(raw_damage, is_crit = false, is_super_crit = false):
	if is_super_crit:
		return parent.crit_damage*2*(raw_damage*damage_mul) + damage_flat
	elif is_crit:
		return parent.crit_damage*(raw_damage*damage_mul) + damage_flat
	else:	
		return (raw_damage*damage_mul) + damage_flat
	
func is_crit():
	return parent.crit_chance >= randf()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("attack") or Input.is_action_pressed("alt_attack")) and $AttackDelay.is_stopped():
		look_at(get_global_mouse_position())
		# Create a new instance of the Attack scene.
		var attack = primary_attack_scene.instantiate() if Input.is_action_pressed("attack") else secondary_attack_scene.instantiate()
		attack.position = Vector2(attack.offset, 0)
		attack.rotation = PI/2
		# Spawn the attack by adding it to the Main scene.
		add_child(attack)
		attack.is_crit = is_crit()
		$AttackDelay.start(attack.attack_delay)
