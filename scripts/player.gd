extends CharacterBody2D
@export var speed = 300
@export var health = 100
@export var damage = 15

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

var is_attacking = false

func player_movement():
	#Player Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	#Player animation
	if not is_attacking:
		if direction == Vector2.ZERO:
			animation.play("idle")
		else:
			if abs(direction.x) > abs(direction.y):
				animation.play("walk_side")
				sprite.scale.x = -1 if direction.x < 0 else 1
			elif direction.y < 0:
				animation.play("walk_up")
			else:
				animation.play("walk_down")


func player_attack_animation():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		animation.play("attack_tail")
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack_tail":
		is_attacking = false
		
		
func _physics_process(delta):
	player_movement()
	player_attack_animation()


func _on_attack_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
