extends Area2D

@export var speed = 600
@export var damage = 50
var direction = Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free() 
	elif body.is_in_group("walls"):
		queue_free()
