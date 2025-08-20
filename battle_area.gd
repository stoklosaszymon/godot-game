extends Node2D

@onready var label = $Canvas/Label
@onready var units = $Units

@export var enemy_units = []
var enemy_id = "enemy_id_1"
var player_finished = false
var spacing = 150
	
func _ready() -> void:
	place_units()
	place_enemy_units()
	get_tree().paused = true

func get_screen_width() -> int:
	return get_viewport_rect().size.x

func place_units():
	var tile_offset_player := Vector2i(-1 * get_screen_width(), 0)
	
	for i in range(PlayerState.units.size()):
		var unit = PlayerState.units[i].instantiate()
		unit.original_scene = PlayerState.units[i]
		unit.team = "player"
		
		if unit.team == "player":
			var grid_pos = tile_offset_player + Vector2i(0, -500 + i * spacing)
			unit.global_position = grid_pos
		
		units.add_child(unit)

func place_enemy_units():
	var tile_offset_enemy :=  Vector2i(get_screen_width(), 0)
	
	for i in range(enemy_units.size()):
		var unit = enemy_units[i].instantiate()
		unit.original_scene = enemy_units[i]
		unit.team = "enemy"
		
		var grid_pos = tile_offset_enemy + Vector2i(0, -500 + i * spacing)
		unit.global_position = grid_pos
		
		units.add_child(unit)

func _process(_delta: float) -> void:
	var player_left_units = 0
	var enemy_left_units = 0
	var units = units.get_children()
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
	print("units left: ", units.get_children().size())
	for unit in units.get_children():
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
