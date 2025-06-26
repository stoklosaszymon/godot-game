extends CanvasLayer

@onready var inventory = $Inventory

var is_inventory_open = false

func _on_texture_button_pressed() -> void:
	is_inventory_open = !is_inventory_open
	if is_inventory_open:
		inventory.show_items(PlayerState.inventory)
	else:
		inventory.hide_ui();
