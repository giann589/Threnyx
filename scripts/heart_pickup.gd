extends Area2D


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("heal"):
			body.heal()
		queue_free()
