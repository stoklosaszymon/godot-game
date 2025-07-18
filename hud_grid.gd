extends Control

@onready var grid = $Panel/GridContainer
var slot_scene = preload("res://slot.tscn")
var dragged_item = null

func clear_grid():
	for child in grid.get_children():
		child.queue_free()

func show_items():
	clear_grid()
	var items = GameManager.get_target_inventory()
	if items:
		for item in items:
			add_slot(item)
		
func show_player_items():
	clear_grid()
	var items = PlayerState.inventory
	for item in items:
		add_slot(item)

func add_slot(item: ItemData): 
	var slotItem = slot_scene.instantiate()
	slotItem.item_data = item
	slotItem.item_dropped_on_slot.connect(handle_item_drop)
	if get_parent().name == "Invenotry":
		slotItem.add_to_group("Inventory")
	grid.add_child(slotItem)
	
func handle_item_drop(drag_data: Dictionary):
	dragged_item = drag_data.item_data
	if name == "TargetInventoryGrid":
		GameManager.remove_item_from_target(drag_data.item_data, PlayerState.inventory)
		GameManager.add_item_to_target(dragged_item, GameManager.chests_data[GameManager.target_inventory_id])
		
	if name == "InventoryGrid":
		GameManager.remove_item_from_target(drag_data.item_data, GameManager.chests_data[GameManager.target_inventory_id])
		GameManager.add_item_to_target(dragged_item, PlayerState.inventory)
	
	if GameManager.target_inventory != null:
		GameManager.target_inventory.open();
		
	if GameManager.target_inventory != null:
		GameManager.inventory.open();
