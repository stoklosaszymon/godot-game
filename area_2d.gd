extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.z_index = 6


func _on_body_exited(body: Node2D) -> void:
		if body.name == "Player":
			body.z_index = 3
