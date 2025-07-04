extends Control

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data")
	
func _drop_data(at_position: Vector2, data: Variant):
	if data is Dictionary and data.has("item_data") && data.item_data.item_name == "Key":
		get_parent().is_locked = false
		get_parent().toggle_chest()
