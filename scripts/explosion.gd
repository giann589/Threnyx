extends Node2D

@onready var animation = $AnimatedSprite2D

func _ready():
	if has_node("AnimatedSprite2D"):
		animation.play("explosion")
		
	await animation.animation_finished
	queue_free()
