extends TileMapLayer

func _process(_delta: float) -> void:
	if PlayerState.is_upladder:
		visible = true
	else:
		visible = false
