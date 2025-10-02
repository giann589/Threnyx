extends Node2D

func show_death_screen():
	#get_tree().paused = true
	$DeathScreen.visible = true

func show_win_screen():
	get_tree().paused = true
	$Win_Screen.visible = true
