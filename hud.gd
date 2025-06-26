extends CanvasLayer

@onready var inventory = $Inventory

var is_inventory_open = false

func _on_texture_button_pressed() -> void:
	is_inventory_open = !is_inventory_open
	if is_inventory_open:
		inventory.open()
	else:
		inventory.close()

func _on_target_inventory_reload() -> void:
	$TargetInventory.close();
	inventory.close()
