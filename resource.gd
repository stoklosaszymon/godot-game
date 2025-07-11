extends StaticBody2D

@export var amount = 3;

func _process(delta: float) -> void:
	if amount == 0:
		GameManager.curently_gathered = null;
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		area.get_parent().z_index = 4;

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		area.get_parent().z_index = 1;

func take():
	amount -= 1;
