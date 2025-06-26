extends Control

@onready var grid = $Panel/GridContainer

func _ready():
	visible = false

func clear_grid():
	for child in grid.get_children():
		child.queue_free()

func show_items(items: Array):
	visible = true
	clear_grid()
	for item in items:
		var label = Label.new()
		label.text = item
		grid.add_child(label)

func hide_ui():
	visible = false
