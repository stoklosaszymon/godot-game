extends Control

@onready var grid = $HUDGrid

func open():
	grid.show_items(PlayerState.inventory)
	
func close():
	grid.hide_ui();
