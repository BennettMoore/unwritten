extends Entity

class_name Player
## An abstract class for all player characters
##
## Handles all the boilerplate found across all character types
## @author: Bennett Moore 2024

@export var melee_damage = 10.0 ## The "melee damage" stat of the player
@export var magic_damage = 10.0 ## The "magic damage" stat of the player
@export var ranged_damage = 10.0 ## The "ranged damage" stat of the player
@export_range(0,2,0.01) var crit_chance = 0.05 ## The percent chance of a critical hit occuring
@export_range(0,10,0.1) var crit_damage = 2.0 ## The damage multiplier used when getting a crit

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox


## Called when the node enters the scene tree for the first time.
func _ready():
	healthBar = %HealthBar
	is_enemy = false
	setStats()
	hide()

## Sets the base stats and data for each character
func setStats():
	PlayerData.armor = armor
	PlayerData.melee_damage = melee_damage
	PlayerData.magic_damage = magic_damage
	PlayerData.ranged_damage = ranged_damage
	PlayerData.speed = speed
	PlayerData.max_hp = max_hp
	PlayerData.hp = hp
	PlayerData.crit_chance = crit_chance
	PlayerData.crit_damage = crit_damage

## Called every frame. 'delta' is the elapsed time since the previous frame.
func moveEntity(delta=0):
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("dodge") and $DodgeTimer.is_stopped():
		dodge_vector = velocity.normalized() * speed * 2
		$DodgeTimer.start(dodge_timer)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed + (dodge_vector * sqrt($DodgeTimer.get_time_left() / dodge_timer))
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	move_and_slide()
	
## Starts the player at a given location
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

## Kills the player
func die():
	queue_free()
