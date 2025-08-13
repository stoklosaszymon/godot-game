extends StaticBody2D

var panel: Control = null
var player_nearby = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = true
		area.get_parent().z_index = 4

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "PlayerArea":
		player_nearby = false
		area.get_parent().z_index = 1
		if panel != null:
			if GameManager.inventory != null:
				GameManager.inventory.close()
			toggle_panel()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and player_nearby and event.button_index == 1:
		toggle_panel()
		if GameManager.inventory == null:
			GameManager.hud.instantiate_inventory()
			
func toggle_panel():
	if  panel == null:
		panel = load("res://building_panel.tscn").instantiate()
		GameManager.hud.add_child(panel)
	elif panel != null and is_instance_valid(panel):
		panel.queue_free()
		panel = null
		
func _process(_delta):
	if !GameManager.player:
		return

	var shader_mat := $TextureRect.material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("screen_size", get_viewport().get_visible_rect().size)
