extends CharacterBody2D

@onready var walk_sprite = $Walk
@onready var attack_sprite = $Attack

const TILE_WIDTH := 500
const TILE_HEIGHT := 250
const SPEED := 200

var grid_position: Vector2i
var target_grid_position: Vector2i
var target_position: Vector2
var is_attacking := false
var team = ""
var direction = Vector2i(0, -1)

var hp = 15
var dmg = 5
var target: Node

func _ready():
	team = get_parent().name
	grid_position = iso_to_grid(global_position)
	direction = Vector2i(0, -1) if team == "PlayerUnits" else Vector2i(0, 1)
	target_grid_position = grid_position + direction
	target_position = grid_to_iso(target_grid_position)
	global_position = grid_to_iso(grid_position)
	update_walk_animation()

func _process(delta: float) -> void:
	#print(name + ": ", hp)
	if hp <= 0:
		die()

func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
		update_attack_animation()
		return
	
	if global_position.distance_to(target_position) < 2.0:
		grid_position = target_grid_position
		target_grid_position += direction
		target_position = grid_to_iso(target_grid_position)
		update_walk_animation()

	var dir_vector = (target_position - global_position).normalized()
	velocity = dir_vector * SPEED
	move_and_slide()

func update_walk_animation():
	var world_dir = grid_dir_to_world_dir(direction)
	var dir_name = get_direction_name(world_dir)
	walk_sprite.show()
	attack_sprite.hide()
	if not walk_sprite.is_playing() or walk_sprite.animation != dir_name:
		walk_sprite.play(dir_name)

func update_attack_animation():
	var world_dir = grid_dir_to_world_dir(direction)
	var dir_name = get_direction_name(world_dir)
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
	print(area.name)
	if area.get_parent().team != team:
		target = area.get_parent()
		is_attacking = true

func _on_attack_animation_finished() -> void:
	print("finished animation")
	if is_instance_valid(target):
		target.hp -= dmg
	
func die():
	queue_free()


func _on_area_2d_area_exited(area: Area2D) -> void:
	is_attacking = false
