extends CharacterBody2D

var health = 100
var speed = 100
var last_facing_direction = Vector2.DOWN
var player_visible = false
var player_in_range = false

@export var bullet_scene: PackedScene
@export var heart_pickup_scene: PackedScene
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
	shoot_timer.start()


func _process(delta):
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
			velocity = Vector2.ZERO
			update_animation_direction(dir)
		else:
			velocity = dir * chase_speed
			update_run_animation()

		last_facing_direction = dir
	else:
		update_run_animation()
		velocity = Vector2.ZERO
		
	move_and_slide()

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
		drop_heal_pickup()
		queue_free()
		
func drop_heal_pickup():
	if heart_pickup_scene:
		var pickup = heart_pickup_scene.instantiate()
		get_parent().add_child(pickup)
		pickup.global_position = global_position

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
			sprite.play("walk_right")
			shoot_pointer.position = BULLET_LOCATIONS["right"]
		else:
			sprite.play("walk_left")
			shoot_pointer.position = BULLET_LOCATIONS["left"]
	else:
		if last_facing_direction.y > 0:
			sprite.play("walk_down")
			shoot_pointer.position = BULLET_LOCATIONS["down"]
		else:
			sprite.play("walk_up")
			shoot_pointer.position = BULLET_LOCATIONS["up"]
