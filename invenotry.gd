extends Control

@onready var grid = $HUDGrid

func _ready():
	grid.show_items(PlayerState.inventory)
	
func close():
	self.queue_free()
