extends CharacterBody2D

var shoot_cooldown = 2.0

@export var health = 100
@export var speed = 100
@export var bullet_scene: PackedScene

@onready var shoot_timer = $Shoot_Timer
@onready var shoot_pointer = $Bullet_Spawner
@onready var player: Node2D = get_tree().get_first_node_in_group("player")


func _ready():
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.start()


func _process(delta):
	if player:
		look_at(player.global_position)

func _on_shoot_timer_timeout():
	if player:
		shoot()
		
func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	bullet.global_position = shoot_pointer.global_position
	bullet.direction = (player.global_position - bullet.global_position).normalized()
	

func take_damage(amount) -> void:
	health -= amount
	print("Enemy health:", health)
	if health <= 0:
		queue_free()
		
		
