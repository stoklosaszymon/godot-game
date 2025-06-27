extends Control

@onready var grid = $HUDGrid
var target: Node = null
var items: Array[ItemData] = []

func open():
	grid.show_items(items)
	
func close():
	self.queue_free()

func _on_claim_all_pressed() -> void:
	PlayerState.inventory.append_array(items)
	items = [];
	if GameManager.target_inventory != null:
		GameManager.target_inventory.close()
	if GameManager.inventory != null:
		GameManager.inventory.close()
	if target != null:
		target.clear()
