extends TileMapLayer

func _drop_data(at_position: Vector2, data: Variant):
	if data is Dictionary and data.has("item_data"):
		print("drop")
		
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.has("source_slot_node")
