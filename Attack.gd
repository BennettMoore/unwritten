extends Area2D
## The abstract class of all attacks
##
## Applies to melee, ranged, and magical attacks
## @author: Bennett Moore 2024

@export var crit_effect: PackedScene = load("res://crit_effect.tscn") ## The "Crit!" visual effect object
@export var damage = 20 ## The base damage of the attack
@export var offset = 100 ## How far away the attack should be from the player upon spawning in pixels
@export var knockback = 200 ## How far away the attack should knock the target back
@export var attack_delay = 1.0 ## How long until the player can attack again
@export var damage_type: Global.DAMAGE_TYPES = Global.DAMAGE_TYPES.NONE ## The damage type of the attack
@export var is_crit = false ## Whether or not the given attack is a crit (Should *always* be false by default)
@export var is_ranged = false ## Whether the attack should use melee or ranged logic
@export var speed = 0.0 ## How fast attack should move in pixels/sec (melee attacks should normally have a speed of 0)
@export_range(0,10,1, "or_greater") var piercing = 0 ## How many times the attack should pierce enemies before being destroyed (ranged only)
@onready var parent: AttackPivot = get_parent()

## Called when the node enters the scene tree for the first time.
func _ready():
	if is_ranged:
		reparent(get_node("/root/Main"))

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if speed != 0:
		position -= transform.y * speed * delta

## Called when the attack fizzles out
func _on_lifetime_timeout():
	destroyed()

## Handles any death logic for the attack/projectile
func destroyed():
	queue_free()

## Called whenever the attack hits something
func _on_body_entered(body):
	if is_crit:
		var crit_text = crit_effect.instantiate()
		add_child(crit_text)
		crit_text.global_rotation = 0
	if body.is_enemy:
		var data = AttackData.new(parent.calculate_attack(damage, is_crit), knockback, damage_type)
		body.onHit(data, parent.global_position)
		print(body.hp)
		if is_ranged && piercing > 0:
			piercing -= 1;
		elif is_ranged:
			destroyed()
