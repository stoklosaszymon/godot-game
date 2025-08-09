extends Node2D

@onready var label = $Control/Label

func _process(delta: float) -> void:
	var player_units = 0
	var enemy_units = 0
	var units = $Units.get_children()
	for unit in units:
		if  unit.get("team") && unit.team == 'player':
			player_units += 1
		else:
			enemy_units += 1
			
	label.text = str(player_units) + " | " +  str(enemy_units)
