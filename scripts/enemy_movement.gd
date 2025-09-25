extends Node2D
@export var speed = 100

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D


func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta
