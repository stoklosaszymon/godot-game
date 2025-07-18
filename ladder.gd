extends Node2D

var player_nearby = false
@export var flip = false

func _ready() -> void:
	$Sprite2D.flip_h = flip

func _on_bottom_area_entered(_area: Area2D) -> void:
	if PlayerState.is_upladder == true:
		PlayerState.is_climbing = false
		PlayerState.setWalkSprite()
		PlayerState.is_upladder = false
		GameManager.player.colision.set_deferred("disabled", false)
		if flip:
			GameManager.player._animated_sprite.flip_h = false

func _on_top_area_entered(_area: Area2D) -> void:
	if PlayerState.is_upladder == false:
		PlayerState.is_climbing = false
		PlayerState.setWalkSprite()
		PlayerState.is_upladder = true
		GameManager.player.colision.set_deferred("disabled", false)
		if flip:
			GameManager.player._animated_sprite.flip_h = false

func _on_ladder_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 and player_nearby:
		GameManager.player.z_index = 5;
		PlayerState.climb_ladder()
		if PlayerState.is_upladder:
			GameManager.player.global_position = Vector2(global_position.x, global_position.y - 60)
		else:
			if flip:
				GameManager.player.global_position = Vector2(global_position.x, global_position.y + 60)
			else:	
				GameManager.player.global_position = Vector2(global_position.x + 10, global_position.y + 60)
		if flip:
			GameManager.player._animated_sprite.flip_h = true

		GameManager.player.colision.set_deferred("disabled", true)


func _on_ladder_area_entered(_area: Area2D) -> void:
	player_nearby = true


func _on_ladder_area_exited(_area: Area2D) -> void:
	player_nearby = false
