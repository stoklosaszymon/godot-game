extends GridContainer

	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.has("source_slot_node")
	
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	
	var dragged_item = data.item_data
	
	if get_parent().get_parent().name == "TargetInventoryGrid":
		GameManager.add_item_to_chest(dragged_item)
		
	if get_parent().get_parent().name == "InventoryGrid":
		GameManager.add_item_to_inventory(dragged_item)
	
	GameManager.target_inventory.open();
	GameManager.inventory.open();
