extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		GameManager.player = body
		SceneTransition.go_to("res://cave.tscn", false, "res://main.tscn")
		
