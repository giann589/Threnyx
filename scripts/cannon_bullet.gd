extends Area2D

@export var damage = 2
@export var speed = 800
@export var explosion_scene: PackedScene

var direction: Vector2

func _ready():
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		explode()
	elif body.is_in_group("walls"):
		explode()
	queue_free()
	

func explode():
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_parent().add_child(explosion)
	queue_free()
