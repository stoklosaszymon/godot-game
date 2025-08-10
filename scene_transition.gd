extends Node

var previous_scene_path: String = ""
var player_spawn_node: String = "PlayerSpawnPoint"
var player_return_node: String = "PlayerReturnPoint"
var battle_scene: PackedScene = load("res://battle_area.tscn")
var current_enemy: Node = null;
	
func go_to(scene_path: String, use_return_point := false, return_path := "") -> void:
	if GameManager.player == null:
		push_error("Player not set in GameManager.")
		return

	var old_scene = get_tree().current_scene
	GameManager.player.get_parent().remove_child(GameManager.player)

	if return_path != "":
		previous_scene_path = return_path

	var new_scene = load(scene_path).instantiate()
	
	await get_tree().process_frame
	
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	old_scene.queue_free()

	await get_tree().process_frame

	var spawn_node_name = player_return_node if use_return_point else player_spawn_node
	var spawn_point = new_scene.get_node_or_null(spawn_node_name)

	if GameManager.minimap == null:
		var minimap = load("res://mini_map.tscn").instantiate()
		GameManager.minimap = minimap
		new_scene.add_child(minimap)

	if GameManager.hud == null:
		var hud = load("res://hud.tscn").instantiate()
		GameManager.hud = hud
		new_scene.add_child(hud)

	if spawn_point:
		GameManager.player.global_position = spawn_point.global_position
	else:
		print("⚠️ Spawn point not found in new scene: ", spawn_node_name)

	new_scene.get_node("GameObjects").add_child(GameManager.player)

func go_back():
	if previous_scene_path == "":
		push_error("No previous scene path stored!")
		return

	go_to(previous_scene_path, true)

func start_battle(enemy):
	current_enemy = enemy
	if GameManager.main_map:
		GameManager.main_map.visible = false

	if GameManager.player:
		GameManager.player.visible = false
		GameManager.player.camera.enabled = false

	if battle_scene:
		GameManager.battle_instance = battle_scene.instantiate()
		get_tree().current_scene.add_child(GameManager.battle_instance)
		GameManager.battle_instance.global_position = Vector2.ZERO

func finish_battle(is_win: bool):
	print("battle result: ", is_win)
	if is_instance_valid(GameManager.battle_instance):
		GameManager.battle_instance.queue_free()
		GameManager.battle_instance = null

	if GameManager.main_map:
		GameManager.main_map.visible = true

	if GameManager.player:
		GameManager.player.visible = true
		GameManager.player.camera.enabled = true
	
	if is_win:
		current_enemy.defeat()
		current_enemy = null
