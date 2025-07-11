extends Node

@export var player_scene: PackedScene = preload("res://character_body_2d.tscn")

func _ready():
	if !GameManager.player:
		var player = player_scene.instantiate()
		var start_point = $PlayerStartPoint.global_position
		player.global_position = start_point
		add_child(player)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.player = body
		SceneTransition.go_to("res://cave.tscn", false, "res://main.tscn")
