extends Entity
## Placeholder Enemy AI
##
## Patrols back and forth between two points
## @author: Bennett Moore 2024

@export var limit = 5
@export var damage = 10
@export var damageType: Global.DAMAGE_TYPES = Global.DAMAGE_TYPES.SLASHING
@export var endpoint: Marker2D
@onready var animations = $AnimationPlayer
var startPosition
var endPosition
var attack = AttackData.new(damage, 0, damageType)


func _ready():
	startPosition = position
	endPosition = endpoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	
func updateVeclocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed
	
func updateAnimation():
	var animationString = "walkUp"
	if velocity.y > 0:
		animationString = "walkDown"
	animations.play(animationString)

func moveEntity(delta=0):
	updateVeclocity()
	move_and_slide()
	updateAnimation()
