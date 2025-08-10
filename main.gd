extends Node

@export var player_scene: PackedScene = preload("res://character_body_2d.tscn")

func _ready():
	if GameManager.player == null:
		var player = player_scene.instantiate()
		var start_point = $MainScene/PlayerStartPoint.global_position
		player.global_position = start_point
		$MainScene/GameObjects.add_child(player)
		
		#var mule = preload("res://mule.tscn").instantiate()
		#mule.global_position = start_point
		#$GameObjects.add_child(mule)
		
	if GameManager.minimap == null:
		var minimap = load("res://mini_map.tscn").instantiate()
		GameManager.minimap = minimap
		add_child(minimap)
		
	if GameManager.hud == null:
		var hud = load("res://hud.tscn").instantiate()
		add_child(hud)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_minimap"):
		GameManager.togggle_map()

func _on_enter_dungeon_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.player = body
		SceneTransition.go_to("res://cave.tscn", false, "res://main.tscn")
