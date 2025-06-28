extends PanelContainer

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.has("source_slot_node")

func _drop_data(at_position: Vector2, data: Variant):
	print(data.item_data)
	PlayerState.equipped_item = data.item_data as ItemData;
