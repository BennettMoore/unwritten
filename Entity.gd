extends CharacterBody2D

class_name Entity
## Parents of all game entities
##
## Handles boilerplate data and logic found in all living things
## @author: Bennett Moore 2024

@export_range(0,1000) var speed = 300 ## How fast the entity will move (pixels/sec).
@export_range(10,1000) var max_hp = 100 ## The maximum health of the entity
@export var hp = max_hp ## The current health of the entity
@export_range(0,1000) var armor = 0 ## The damage reduction value of the entity
@export_range(0,5,0.01) var dodge_timer = 0.35 ## How long the entity dodges for in seconds
@export_range(0,5,0.01) var hurt_timer = 0.2 ## How long the entity's I-frames are in seconds
@export var is_enemy = true ## Whether or not the player and their allies can damage this entity
@onready var healthBar = null
@onready var dodge_vector = Vector2.ZERO
@onready var knockback_vector = Vector2.ZERO

func _process(delta):
	if not $HurtTimer.is_stopped():
		var hurt_color = 1-($HurtTimer.get_time_left() / hurt_timer)
		modulate = Color(1, hurt_color, hurt_color)
	elif not $DodgeTimer.is_stopped():
		var dodge_color = 1-sqrt($DodgeTimer.get_time_left() / dodge_timer)
		modulate = Color(dodge_color, dodge_color, dodge_color)
	else:
		modulate = Color(1, 1, 1)
		knockback_vector = Vector2.ZERO

func onHit(data: AttackData, attackPos = global_position):
	if $DodgeTimer.is_stopped() and $HurtTimer.is_stopped():
		hp -= data.damage
		if healthBar != null: # Only update healthbar if you have one
			healthBar.update()
		if max_hp < hp: # Prevent overhealth
			hp = max_hp
		if hp <= 0: # If you don't have health, then you die
			die()
		else:
			$HurtTimer.start(hurt_timer)
			if data.knockback != 0:
				knockback_vector = -(global_position.direction_to(attackPos) * data.knockback)
				print(knockback_vector)

func moveEntity(delta=0):
	pass
	
func _physics_process(delta):
	moveEntity(delta)
	if not $HurtTimer.is_stopped():
		velocity = (knockback_vector * sqrt($HurtTimer.get_time_left() / hurt_timer))
		move_and_slide()

func die():
	queue_free()
