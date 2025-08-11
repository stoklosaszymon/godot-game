extends Node2D

@onready var label = $Canvas/Label

func _ready() -> void:
	get_tree().paused = true

func _process(_delta: float) -> void:
	var player_units = 0
	var enemy_units = 0
	var units = $Units.get_children()
	for unit in units:
		if  unit.get("team") && unit.team == 'player':
			player_units += 1
		else:
			enemy_units += 1
			
	label.text = str(player_units) + " | " +  str(enemy_units)
	
	if player_units == 0:
		battle_finished(false)
	elif enemy_units == 0:
		battle_finished(true)

func battle_finished(is_win: bool):
	clean_up_battle_area()
	SceneTransition.finish_battle(is_win)

func _on_button_pressed() -> void:
	get_tree().paused = false
	$Canvas/Button.visible = false

func clean_up_battle_area():
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		if is_instance_valid(projectile):
			projectile.queue_free()
