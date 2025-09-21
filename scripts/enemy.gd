extends CharacterBody2D
@export var health = 100
@export var speed = 100
#@export var damange = 15

func take_damage(amount) -> void:
	health -= amount
	print("Enemy health:", health)
	if health <= 0:
		queue_free()
		
		
		
func _physics_process_():
	pass
