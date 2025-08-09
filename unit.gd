extends CharacterBody2D

@export var team = ""
@onready var walk_sprite = $Walk
@onready var attack_sprite = $Attack
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const TILE_WIDTH := 500
const TILE_HEIGHT := 250
const SPEED := 200

var grid_position: Vector2i
var target_grid_position: Vector2i
var target_position: Vector2
var is_attacking := false

var direction = Vector2.ZERO

var hp = 15
var dmg = 5
var target: Node

func _ready():
	grid_position = iso_to_grid(global_position)
	direction = Vector2(0, -1) if team == "player" else Vector2(0, 1)
	target_grid_position = grid_position + Vector2i(direction.x, direction.y)
	target_position = grid_to_iso(target_grid_position)
	global_position = grid_to_iso(grid_position)
	update_walk_animation_with_direction(direction)
	set_closest_enemy_target()

func set_closest_enemy_target():
	var enemies = get_parent().get_children()
	
	var closest_enemy = null
	var closest_dist = INF
	
	for enemy in enemies:
		if enemy == self or not is_instance_valid(enemy):
			continue
		var enemy_team = enemy.get("team")
		if enemy_team == null:
			continue
		if enemy_team != team:
			var dist = global_position.distance_to(enemy.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest_enemy = enemy
	
	if closest_enemy:
		target = closest_enemy
		navigation_agent.target_position = closest_enemy.global_position
		is_attacking = false
		print(name, "targeting", closest_enemy.name)

func _process(delta: float) -> void:
	if hp <= 0:
		die()

func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
		direction = (target.global_position - global_position).normalized()
		update_attack_animation()
		return
	
	if not target or not is_instance_valid(target):
		set_closest_enemy_target()
		return
	
	navigation_agent.target_position = target.global_position
	
	if navigation_agent.is_navigation_finished():
		print("target reached")
		#s_attacking = true
		#velocity = Vector2.ZERO
		#update_attack_animation()
	else:
		var next_path_position = navigation_agent.get_next_path_position()
		var move_dir = (next_path_position - global_position).normalized()
		velocity = move_dir * SPEED
		move_and_slide()
		
		direction = move_dir
		update_walk_animation_with_direction(direction)

func update_walk_animation_with_direction(world_dir: Vector2) -> void:
	var dir_name = get_direction_name(world_dir)
	walk_sprite.show()
	attack_sprite.hide()
	if not walk_sprite.is_playing() or walk_sprite.animation != dir_name:
		walk_sprite.play(dir_name)

func update_attack_animation():
	var dir_name = get_direction_name(direction)
	walk_sprite.hide()
	attack_sprite.show()
	if not attack_sprite.is_playing() or attack_sprite.animation != dir_name:
		attack_sprite.play(dir_name)

func grid_to_iso(grid: Vector2i) -> Vector2:
	return Vector2(
		(grid.x - grid.y) * TILE_WIDTH / 2,
		(grid.x + grid.y) * TILE_HEIGHT / 2
	)

func iso_to_grid(pos: Vector2) -> Vector2i:
	var x = ((pos.x / (TILE_WIDTH / 2)) + (pos.y / (TILE_HEIGHT / 2))) / 2
	var y = ((pos.y / (TILE_HEIGHT / 2)) - (pos.x / (TILE_WIDTH / 2))) / 2
	return Vector2i(round(x), round(y))

func grid_dir_to_world_dir(grid_dir: Vector2i) -> Vector2:
	var world_dir = Vector2(
		(grid_dir.x - grid_dir.y) * TILE_WIDTH / 2,
		(grid_dir.x + grid_dir.y) * TILE_HEIGHT / 2
	)
	return world_dir.normalized()

func get_direction_name(dir: Vector2) -> String:
	var angle = dir.angle()
	var degrees = rad_to_deg(angle)
	if degrees < 0:
		degrees += 360

	if degrees < 22.5 or degrees >= 337.5:
		return "E"
	elif degrees < 67.5:
		return "SE"
	elif degrees < 112.5:
		return "S"
	elif degrees < 157.5:
		return "SW"
	elif degrees < 202.5:
		return "W"
	elif degrees < 247.5:
		return "NW"
	elif degrees < 292.5:
		return "N"
	else:
		return "NE"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().team != team:
		target = area.get_parent()
		is_attacking = true

func _on_attack_animation_finished() -> void:
	if is_instance_valid(target):
		print(name, "attacked", target.name)
		target.hp -= dmg

func die():
	queue_free()

func _on_area_2d_area_exited(area: Area2D) -> void:
	is_attacking = false
