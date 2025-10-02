extends CharacterBody2D

var health = 500
var speed = 100
var last_facing_direction = Vector2.DOWN
var player_visible = false
var player_in_range = false
var start_y = 0
var move_distance = 200
var moving_up = false
var active = false

@export var bullet_scene: PackedScene
@export var cannon_bullet_scene: PackedScene
@export var detection_range = 500
@export var attack_range = 250
@export var chase_speed = 150

@onready var shoot_timer = $Shoot_Timer
@onready var shoot_pointer = $Bullet_Spawner
@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var ray: RayCast2D = $RayCast2D
@onready var sprite = $AnimatedSprite2D

#Used for changing bullet_spawner depending on where the enemy is looking
const BULLET_LOCATIONS = {
	"up": Vector2(0, -10),
	"down": Vector2(0, 10),
	"left": Vector2(-10, 0),
	"right": Vector2(10, 0),
	}


func _ready():
	start_y = global_position.y
	shoot_timer.start()


func _process(delta):
	if not active:
		return
	
	if moving_up:
		global_position.y -= speed * delta
		if global_position.y <= start_y - move_distance:
			moving_up = false
	else:
		global_position.y += speed * delta
		if global_position.y >= start_y + move_distance:
			moving_up = true
	var dist_to_player = global_position.distance_to(player.global_position)

	if dist_to_player <= detection_range and can_see_player():
		player_visible = true
	else:
		player_visible = false

	player_in_range = dist_to_player <= attack_range

	#Find player 
	if player_visible:
		var dir = (player.global_position - global_position).normalized()

		if player_in_range:
			update_animation_direction(dir)
		else:
			update_run_animation()

		last_facing_direction = dir
	else:
		update_run_animation()

func _on_shoot_timer_timeout():
	if player_visible:
		shoot()
		
func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	bullet.global_position = shoot_pointer.global_position
	bullet.direction = (player.global_position - bullet.global_position).normalized()
	bullet.rotation = bullet.direction.angle()
	
func can_see_player() -> bool:
	if not player:
		return false
	ray.target_position = to_local(player.global_position)
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("player"):
			return true
	return false
	
func take_damage(amount) -> void:
	health -= amount
	print("Enemy health:", health)
	if health <= 0:
		queue_free()
		
func update_animation_direction(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.play("look_right")  
		else:
			sprite.play("look_left")
	else:
		if direction.y > 0:
			sprite.play("look_down")
		else:
			sprite.play("look_up")

func update_run_animation():
	if abs(last_facing_direction.x) > abs(last_facing_direction.y):
		if last_facing_direction.x > 0:
			sprite.play("move_right")
			shoot_pointer.position = BULLET_LOCATIONS["right"]
		else:
			sprite.play("move_left")
			shoot_pointer.position = BULLET_LOCATIONS["left"]
	else:
		if last_facing_direction.y > 0:
			sprite.play("move_down")
			shoot_pointer.position = BULLET_LOCATIONS["down"]
		else:
			sprite.play("move_up")
			shoot_pointer.position = BULLET_LOCATIONS["up"]


func _on_cannon_timer_timeout():
	if player_visible:
		shoot_cannon()
		
		
func shoot_cannon():
	var cannon_bullet = cannon_bullet_scene.instantiate()
	get_parent().add_child(cannon_bullet)
	
	cannon_bullet.global_position = shoot_pointer.global_position
	cannon_bullet.direction = (player.global_position - cannon_bullet.global_position).normalized()
	cannon_bullet.rotation = cannon_bullet.direction.angle()
	
	
func _on_boss_trigger_body_entered(body):
	if body.is_in_group("player"):
		active = true
