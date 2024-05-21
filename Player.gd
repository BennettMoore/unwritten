extends Entity

class_name Player

@export var melee_damage = 10.0
@export var magic_damage = 10.0
@export var ranged_damage = 10.0
@export_range(0,2,0.01) var crit_chance = 0.05
@export_range(0,10,0.1) var crit_damage = 2.0

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox


# Called when the node enters the scene tree for the first time.
func _ready():
	healthBar = %HealthBar
	is_enemy = false
	setStats()
	hide()

# Sets the base stats and data for each character
func setStats():
	armor = 10.0
	melee_damage = 10.0
	magic_damage = 10.0
	ranged_damage = 10.0
	speed = 300
	max_hp = 100
	hp = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func die():
	queue_free()
