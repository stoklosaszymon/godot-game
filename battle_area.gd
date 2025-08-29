extends Node2D

@onready var label = $Canvas/Label
@onready var units_node = $Units

@export var enemy_units = []
var enemy_id = "enemy_id_1"
var player_finished = false
var spacing = 150
var min_map_h = -1000
var max_map_h = 1000
var x_offset = 300
	
func _ready() -> void:
	place_units(PlayerState.units, "player", false)
	place_units(enemy_units, "enemy", true)
	get_tree().paused = true

func get_screen_width() -> int:
	return get_viewport_rect().size.x

func place_units(units_list: Array, team: String, is_enemy: bool) -> void:
	var base_offset := Vector2i(
		(get_screen_width() + x_offset) * (1 if is_enemy else -1),
		0
	)

	for i in range(units_list.size()):
		var unit = units_list[i].instantiate()
		unit.original_scene = units_list[i]
		unit.team = team

		var items_per_column = int((max_map_h - min_map_h) / spacing) + 1
		var column = int(i / items_per_column)
		if is_enemy:
			column *= -1

		var row_in_column = i % items_per_column
		var middle = items_per_column / 2
		var offset = int((row_in_column + 1) / 2) * (1 if row_in_column % 2 == 1 else -1)
		var row = middle + offset

		var x_spacing = column * 150
		var y_spacing = row * spacing

		var grid_pos = base_offset + Vector2i(x_spacing, min_map_h + y_spacing)
		unit.global_position = grid_pos
		units_node.call_deferred("add_child", unit)


func _process(_delta: float) -> void:
	var player_left_units = 0
	var enemy_left_units = 0
	var units = units_node.get_children()
	for unit in units:
		if unit.get("team") && unit.team == 'player':
			if !unit.is_dead:
				player_left_units += 1
		else:
			if !unit.is_dead:
				enemy_left_units += 1
			
	label.text = str(player_left_units) + " | " +  str(enemy_left_units)
	
	if player_left_units == 0:
		show_end_button()
		battle_finished(false)
	elif enemy_left_units == 0:
		show_end_button()
		battle_finished(true)

func battle_finished(is_win: bool):
	if !player_finished:
		return
		
	if is_win:
		print("win")
		save_remaining_units(PlayerState.units)
		GameManager.world_enemy_data[enemy_id].clear()
	else:
		print("lost")
		save_remaining_units(GameManager.world_enemy_data[enemy_id])
		print("remeining: ", enemy_id, " with ", GameManager.world_enemy_data[enemy_id].size(), " units")
		PlayerState.units.clear()

	clean_up_battle_area()
	player_finished = false
	SceneTransition.finish_battle(is_win)

func save_remaining_units(units_array):
	units_array.clear()
	for unit in units_node.get_children():
		if not unit.is_dead and unit.original_scene:
			units_array.append(unit.original_scene)
		unit.queue_free()

func _on_button_pressed() -> void:
	get_tree().paused = false
	$Canvas/Start.visible = false

func clean_up_battle_area():
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		if is_instance_valid(projectile):
			projectile.queue_free()

func _on_end_pressed() -> void:
	player_finished = true

func show_end_button():
	$Canvas/End.visible = true;
