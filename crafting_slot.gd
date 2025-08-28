extends "res://slot.gd"

func _get_drag_data(_at_position: Vector2) -> Variant:
	return null

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.item_data.is_resource
