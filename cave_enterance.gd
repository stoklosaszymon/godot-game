extends StaticBody2D

var player_z = 0;

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		z_index = -1



func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		area.z_index = player_z;
