extends Control

@onready var grid = $HUDGrid
var items: Array[String] = []
signal reload

func open(items: Array[String]):
	grid.show_items(items)
	
func close():
	grid.hide_ui()

func _on_claim_all_pressed() -> void:
	PlayerState.inventory.append_array(items)
	items = [];
	
	var chests = get_tree().get_nodes_in_group("chests")
	if chests.size() > 0:
		chests[0].clear()
	
	reload.emit()
