extends Control

@onready var grid = $Panel/GridContainer
var slot_scene = preload("res://slot.tscn")

func clear_grid():
	for child in grid.get_children():
		child.queue_free()

func show_items(items: Array[Resource]):
	visible = true
	clear_grid()
	for item in items:
		var slotItem = slot_scene.instantiate()
		
		slotItem.item_data = item
		grid.add_child(slotItem)

func hide_ui():
	visible = false
