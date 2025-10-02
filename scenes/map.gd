extends Node2D

func show_death_screen():
	get_tree().paused = true
	$DeathScreen.visible = true
