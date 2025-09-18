extends CharacterBody2D
@export var health = 100
@export var speed = 100
@export var damange = 15


func _physics_process(delta):
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	health -= 15
	print(health)
	
	if health <= 0:
		pass
