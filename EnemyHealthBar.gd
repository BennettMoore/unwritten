extends ProgressBar

@onready var enemy = get_node("../Enemy")

func _ready():
	update()

func update():
	value = enemy.hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
