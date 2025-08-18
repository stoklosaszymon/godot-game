extends StaticBody2D

@export var dir: String = "SE"
var player_nearby = false
var panel = null
var panel_scene: PackedScene = preload("res://recruit_panel.tscn")

func _ready() -> void:
	$AnimatedSprite2D.play(dir)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and player_nearby and event.button_index == 1:
		toggle_panel()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = false
		if panel:
			toggle_panel()

func toggle_panel():
	if  panel == null:
		panel = panel_scene.instantiate()
		GameManager.hud.add_child(panel)
	elif panel != null and is_instance_valid(panel):
		panel.queue_free()
		panel = null
		
