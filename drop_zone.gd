extends Control

func _drop_data(position, data):
	GameManager.drop_item(data.item_data)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.has("source_slot_node") and data.source_slot_node.is_in_group("Inventory")
