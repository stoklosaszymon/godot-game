extends Control

@onready var grid = $TargetInventoryGrid
var items: Array[ItemData] = []

func open():
	grid.show_items()
	
func close():
	self.queue_free()

func _on_claim_all_pressed() -> void:
	GameManager.claim_all()
	if GameManager.target_inventory != null:
		GameManager.target_inventory.close()
	if GameManager.inventory != null:
		GameManager.inventory.close()
