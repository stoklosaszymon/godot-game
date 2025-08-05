extends TileMapLayer

var shader = material as ShaderMaterial

func enable_rain():
	shader.set_shader_parameter("enable_rain", true)

func disable_rain():
	shader.set_shader_parameter("enable_rain", false)

func is_player_next_to_river() -> bool:
	if not GameManager.player:
		return false
	
	var player_pos = GameManager.player.global_position
	var adjusted_pos = player_pos + Vector2(0, 90) 
	var cell = local_to_map(adjusted_pos)
	var tile_data = get_cell_tile_data(cell)
	
	return tile_data != null and tile_data.get_custom_data("type") == "river"

func _is_river(cell: Vector2) -> bool:
	var tile_data = get_cell_tile_data(cell)
	return tile_data != null and tile_data.get_custom_data("type") == "river"

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var cell = local_to_map(mouse_pos)
		if _is_river(cell) and is_player_next_to_river():
			AnimationManager.fishing()
