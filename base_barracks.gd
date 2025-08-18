extends StaticBody2D

@export var dir: String = "SE"
@export var recruit_id = "recruit_id_1"
var player_nearby = false
var panel = null
var panel_scene: PackedScene = preload("res://recruit_panel.tscn")
@export var unit: PackedScene = preload("res://unit.tscn")

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
		panel.unit = unit
		panel.building_id = recruit_id
		GameManager.hud.add_child(panel)
	elif panel != null and is_instance_valid(panel):
		panel.queue_free()
		panel = null


func _on_area_2d_mouse_entered() -> void:
	CursorManager.set_cursor_hand()


func _on_area_2d_mouse_exited() -> void:
	CursorManager.set_cursor_arrow()
