extends GridContainer

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.has("source_slot_node") || data.has("equiped_item") 
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var dragged_item = data.item_data
	if data.source_slot_node in get_children():
		return 

	if data.source_slot_node.name == "UseSlot":
		data.source_slot_node.clear()
		GameManager.player.unequip()
	elif get_parent().get_parent().name == "TargetInventoryGrid":
		if GameManager.target_inventory_id != null:
			GameManager.add_item_to_target(dragged_item, GameManager.chests_data[GameManager.target_inventory_id] as Array[ItemData])
			GameManager.remove_item_from_target(dragged_item, PlayerState.inventory)
		
	elif get_parent().get_parent().name == "InventoryGrid":
		GameManager.add_item_to_target(dragged_item, PlayerState.inventory)
		if GameManager.target_inventory_id != null:
			GameManager.remove_item_from_target(dragged_item, GameManager.chests_data[GameManager.target_inventory_id])

	if GameManager.target_inventory != null:
		GameManager.target_inventory.open();

	if GameManager.inventory != null:
		GameManager.inventory.open();
