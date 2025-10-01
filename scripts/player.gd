extends CharacterBody2D
@export var speed = 300
@export var health = 5
@export var damage = 50

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var UI = $UI

var is_attacking = false
var is_hurt = false
var is_dead = false

func _physics_process(delta):
	if is_dead: #Check if player died
		return
	
	player_movement()
	player_attack_animation()


func player_movement():
	#Player Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	#Player animation
	if not is_attacking and not is_hurt:
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
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_hurt:
		is_attacking = true
		animation.play("attack_tail")
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack_tail":
		is_attacking = false
	#elif anim_name == "hurt":
		#is_hurt = false
	elif anim_name == "death":
		queue_free()
		
		
func _on_attack_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			

func take_damage(amount) -> void:
	if is_dead:
		return
	
	health -= amount
	print("Player health:", health)
	
	if UI and UI.has_method("update_hearts"): #Updates Heart Symbol
		UI.update_hearts(health)
	
	if health <= 0:
		is_dead = true
		animation.play("death")
	#Fix needed??
	#else:
		#is_hurt = true
		#animation.play("hurt")
		
	
	
