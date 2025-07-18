extends Control

@export var item_data: ItemData:
	set(new_item_data):
		item_data = new_item_data
		update_visuals()
		
var dragged_item = null;
		
signal item_dropped_on_slot(drag_data, item_data)

func _ready() -> void:
	if item_data != null && item_data.quantity > 1:
		$ItemQuantity.text = str(item_data.quantity)
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_data:
		var preview = Control.new()
		var texture_rect = TextureRect.new()
		texture_rect.texture = item_data.icon
		texture_rect.custom_minimum_size = Vector2(64, 64)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.add_child(texture_rect)
		
		set_drag_preview(preview)
		
		var drag_data = {
			"item_data": item_data,
			"source_slot_node": self
		}
		
		if item_data.is_equipable:
			drag_data["is_equipable"] = true
			
		dragged_item = item_data
		return drag_data
	return null

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.has("source_slot_node") and data.source_slot_node not in get_parent().get_children()

func _drop_data(_at_position: Vector2, data: Variant):
	if data is Dictionary and data.has("item_data"):
		item_dropped_on_slot.emit(self, data)

		
func update_visuals():
	if item_data:
		$VBoxContainer/ItemImg.texture = item_data.icon
		$VBoxContainer/ItemName.text = item_data.item_name
	else:
		$VBoxContainer/ItemImg.texture = null
		$VBoxContainer/ItemName.text = ""
		
