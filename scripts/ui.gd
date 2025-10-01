extends CanvasLayer

@onready var hearts = [
	$HBoxContainer/Heart,
	$HBoxContainer/Heart2,
	$HBoxContainer/Heart3,
	$HBoxContainer/Heart4,
	$HBoxContainer/Heart5]
	
	
func _ready():
	update_hearts(5)

func update_hearts(current_health):
	for i in range(hearts.size()):
		var heart_anim = hearts[i].get_node("Heart")
		if i < current_health:
			heart_anim.play("alive")
		else:
			heart_anim.play("dead")
