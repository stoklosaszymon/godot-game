extends PanelContainer

func _get_drag_data(at_position: Vector2) -> Variant:
	if PlayerState.equipped_item:
		var preview = Control.new()
		var texture_rect = TextureRect.new()
		texture_rect.texture = PlayerState.equipped_item.icon
		texture_rect.custom_minimum_size = Vector2(64, 64)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.add_child(texture_rect)
		name = 'UseSlot'
		set_drag_preview(preview)
		
		var drag_data = {
			"equiped_item" : true,
			"item_data" : PlayerState.equipped_item,
			"source_slot_node": self
		}
			
		return drag_data
	return null

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_data") and data.has("is_equipable")

func _drop_data(at_position: Vector2, data: Variant):
	if PlayerState.equipped_item != null:
		GameManager.player.unequip();
	
	PlayerState.equipped_item = null
	PlayerState.equipped_item = data.item_data as ItemData;
	
	for child in get_children():
		child.queue_free()
		
	set_icon(data.item_data)

func set_icon(item):
	var itemImg = TextureRect.new()
	itemImg.texture = PlayerState.equipped_item.icon
	add_child(itemImg)

func _ready():
	if PlayerState.equipped_item != null:
		set_icon(PlayerState.equipped_item)
		
func clear():
	for child in get_children():
		child.queue_free()
