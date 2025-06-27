extends Control

@onready var grid = $Panel/GridContainer
var slot_scene = preload("res://slot.tscn")

func clear_grid():
	for child in grid.get_children():
		child.queue_free()

func show_items(items: Array[ItemData]):
	clear_grid()
	for item in items:
		add_slot(item)

func add_slot(item: ItemData): 
	var slotItem = slot_scene.instantiate()
	slotItem.item_data = item
	slotItem.item_dropped_on_slot.connect(handle_item_drop)
	grid.add_child(slotItem)
	
func handle_item_drop(target_slot_node: Node, drag_data: Dictionary, ):
	var source_slot_node = drag_data.source_slot_node
	
	var source_container = source_slot_node.get_parent()
	var target_container = target_slot_node.get_parent()
	print(source_container, target_container)
	var dragged_item = drag_data.item_data

	add_slot(dragged_item)
	source_slot_node.queue_free()
	
