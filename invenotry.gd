extends Control

@onready var grid = $InventoryGrid

func _ready():
	grid.show_player_items()
	
func open():
	grid.show_player_items()
	
func close():
	self.queue_free()
