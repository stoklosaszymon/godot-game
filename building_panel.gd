extends Control

@onready var slot1 = $PanelContainer/Slot
@onready var slot2 = $PanelContainer/Slot2

func _ready() -> void:
	slot1.connect("item_dropped_on_slot", handle_drop)
	slot2.connect("item_dropped_on_slot", handle_drop)

func handle_drop(drag_data, item_data):
	if item_data.has("source_slot_node"):
		drag_data.item_data = item_data.item_data
		drag_data.update_visuals()
	print(drag_data)
	print(item_data)
