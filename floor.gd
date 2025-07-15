extends TileMapLayer

func _process(delta: float) -> void:
	if PlayerState.is_upladder:
		visible = true
	else:
		visible = false
