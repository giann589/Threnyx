extends Area2D

@export var damage = 20
@export var speed = 400
var direction: Vector2

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()


	queue_free() 
