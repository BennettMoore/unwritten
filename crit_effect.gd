extends Label


func _on_lifetime_timeout():
	queue_free()
