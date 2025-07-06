extends StaticBody2D

var is_open = false
var panel: Control = null
var player_nearby = false
@onready var hud = get_node("../../HUD")
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = true
		area.get_parent().z_index = 4

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = false
		area.get_parent().z_index = 1
		if is_open:
			toggle_panel()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and player_nearby:
		toggle_panel()
			
func toggle_panel():
	is_open = !is_open

	if is_open:
		if panel == null:
			panel = load("res://building_panel.tscn").instantiate()
			hud.add_child(panel)
	else:
		if panel != null and is_instance_valid(panel):
			panel.queue_free()
			panel = null
