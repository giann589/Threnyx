extends CharacterBody2D
@export var speed = 300
@export var health = 100
@export var damage = 100

@onready var animation = $AnimatedSprite2D


func player_movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	
	move_and_slide()
	
	
	#Player animation
	var last_direction
	if direction == Vector2.ZERO:
		animation.play("idle")
	else:
		if abs(direction.x) > abs(direction.y):
			animation.play("walk_side")
			animation.flip_h = direction.x > 0
		elif direction.y < 0:
			animation.play("walk_up")
		else:
			animation.play("walk_down")

func _physics_process(delta):
	player_movement()
 
