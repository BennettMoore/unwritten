extends Area2D

@export var crit_effect = load("res://crit_effect.tscn")
@export var damage = 20
@export var offset = 100
@export var knockback = 200
@export var attack_delay = 1.0
@export var damage_type = "None"
@export var is_crit = false
@onready var parent: AttackPivot = get_parent()

func _on_lifetime_timeout():
	queue_free()

func _on_body_entered(body):
	if is_crit:
		var crit_text = crit_effect.instantiate()
		add_child(crit_text)
		crit_text.global_rotation = 0
	if body.is_enemy:
		var data = AttackData.new(parent.calculate_attack(damage, is_crit), knockback, false, damage_type)
		body.onHit(data, parent.global_position)
		print(body.hp)
