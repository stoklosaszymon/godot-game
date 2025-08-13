extends CharacterBody2D

@export var team: String = ""
@export var hp: int = 15
@export var dmg: int = 5
@export var attack_range: float = 200.0  
@export var speed: float = 200.0        
@export var separation_distance: float = 200.0 
@export var separation_strength: float = 100.0 

@export var stuck_time_limit: float = 2.0     
@export var stuck_distance_threshold: float = 1.0

@onready var walk_sprite: AnimatedSprite2D = $Walk
@onready var attack_sprite: AnimatedSprite2D = $Attack
@onready var idle_sprite: AnimatedSprite2D = $Idle
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hp_label: Label = $HP

const TILE_WIDTH := 500
const TILE_HEIGHT := 250

var max_hp = 0
var grid_position: Vector2i
var target: Node = null
var is_attacking: bool = false
var direction: Vector2 = Vector2.ZERO

var stuck_timer: float = 0.0
var last_position: Vector2

var last_dir_name := "S"
var direction_change_cooldown := 0.1
var direction_change_timer := 0.0


func _ready():
	max_hp = hp
	grid_position = iso_to_grid(global_position)
	global_position = grid_to_iso(grid_position)
	
	navigation_agent.avoidance_enabled = true
	navigation_agent.radius = 16
	navigation_agent.max_neighbors = 8
	navigation_agent.time_horizon = 1.0
	
	if team == "player":
		set_collision_mask_value(1, false)
	elif team == "enemy":
		set_collision_mask_value(2, false)
	
	last_position = global_position
	set_closest_enemy_target()

func _process(_delta: float) -> void:
	hp_label.text = str(hp) + "/" + str(max_hp)
	if !is_instance_valid(target) and is_attacking:
		is_attacking = false
	if hp <= 0:
		die()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		is_attacking = false
		set_closest_enemy_target()
		if velocity == Vector2.ZERO and !is_instance_valid(target):
			update_idle_animation()
		return
	
	if !is_attacking:
		check_if_stuck(delta)
	
	var dist_to_target = global_position.distance_to(target.global_position)
	if dist_to_target <= attack_range:
		start_attack()
	else:
		move_towards_target(delta)


func check_if_stuck(delta: float):
	var movement = global_position.distance_to(last_position)
	last_position = global_position
	
	if movement < stuck_distance_threshold:
		stuck_timer += delta
	else:
		stuck_timer = 0.0
	
	if stuck_timer >= stuck_time_limit:
		print(name, " is stuck, retargeting...")
		stuck_timer = 0.0
		set_closest_enemy_target()

func set_closest_enemy_target(skip = null):
	var closest_enemy: Node = null
	var closest_dist: float = INF
	
	for child in get_parent().get_children():
		if child == self:
			continue
		if not is_instance_valid(child):
			continue
		if child == skip:
			continue
		if not child.get("team") or child.team == team:
			continue
		
		var dist = global_position.distance_to(child.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = child
	
	if closest_enemy and closest_enemy != target:
		target = closest_enemy
		navigation_agent.target_position = find_attack_position()
		print(name, " targeting ", closest_enemy.name)

func move_towards_target(_delta: float) -> void:
	is_attacking = false
	navigation_agent.target_position = find_attack_position()
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next_path_position = navigation_agent.get_next_path_position()
		var move_dir = (next_path_position - global_position).normalized()
		
		move_dir += separate_from_allies() * (separation_strength / speed)
		move_dir = move_dir.normalized()
		move_dir = eight_dir_snap(move_dir)
		
		velocity = move_dir * speed
		move_and_slide()

		direction = velocity.normalized()
		
		update_walk_animation_with_direction(direction)

func start_attack():
	velocity = Vector2.ZERO
	if !is_attacking:
		direction = (target.global_position - global_position).normalized()
		direction = eight_dir_snap(direction)
	is_attacking = true
	update_attack_animation()


func find_attack_position() -> Vector2:
	if not is_instance_valid(target):
		return global_position
	
	var dir_to_target = (target.global_position - global_position).normalized()
	var side_offset = dir_to_target.rotated(randf_range(-PI / 4, PI / 4)) * 30
	return target.global_position - dir_to_target * (attack_range * 0.8) + side_offset

func separate_from_allies() -> Vector2:
	var push = Vector2.ZERO
	for ally in get_parent().get_children():
		if ally == self:
			continue
		if not is_instance_valid(ally):
			continue
		if not ally.get("team") or ally.team != team:
			continue
		
		var to_self = global_position - ally.global_position
		var dist = to_self.length()
		if dist > 0 and dist < separation_distance:
			push += to_self.normalized() * ((separation_distance - dist) / separation_distance)
	return push.normalized()

func eight_dir_snap(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO:
		return Vector2.ZERO
	
	var angle_step = PI / 4
	var snapped_angle = round(dir.angle() / angle_step) * angle_step
	return Vector2.RIGHT.rotated(snapped_angle).normalized()

func update_walk_animation_with_direction(world_dir: Vector2) -> void:
	if world_dir == Vector2.ZERO:
		return
	
	var dir_name = get_direction_name(world_dir)
	
	if dir_name != last_dir_name:
		direction_change_timer += get_physics_process_delta_time()
		if direction_change_timer >= direction_change_cooldown:
			last_dir_name = dir_name
			direction_change_timer = 0.0
	else:
		direction_change_timer = 0.0
	
	walk_sprite.show()
	attack_sprite.hide()
	idle_sprite.hide()
	if walk_sprite.animation != last_dir_name or not walk_sprite.is_playing():
		walk_sprite.play(last_dir_name)

func update_idle_animation():
	idle_sprite.show()
	attack_sprite.hide()
	walk_sprite.hide()
	if idle_sprite.animation != last_dir_name or not idle_sprite.is_playing():
		idle_sprite.play(last_dir_name)

func update_attack_animation():
	var dir_name = get_direction_name(direction)
	last_dir_name = dir_name
	walk_sprite.hide()
	idle_sprite.hide()
	attack_sprite.show()
	if attack_sprite.animation != dir_name or not attack_sprite.is_playing():
		attack_sprite.play(dir_name)

func grid_to_iso(grid: Vector2i) -> Vector2:
	return Vector2(
		float(grid.x - grid.y) * TILE_WIDTH / 2,
		float(grid.x + grid.y) * TILE_HEIGHT / 2
	)

func iso_to_grid(pos: Vector2) -> Vector2i:
	var half_w := TILE_WIDTH / 2.0
	var half_h := TILE_HEIGHT / 2.0

	var x := ((pos.x / half_w) + (pos.y / half_h)) / 2.0
	var y := ((pos.y / half_h) - (pos.x / half_w)) / 2.0

	return Vector2i(round(x), round(y))

func get_direction_name(dir: Vector2) -> String:
	if dir == Vector2.ZERO:
		return last_dir_name
	var degrees = rad_to_deg(dir.angle())
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

func _on_attack_animation_finished() -> void:
	is_attacking = false

func apply_attack_damage():
	if is_instance_valid(target):
		target.hp -= dmg
			
	is_attacking = false

func die():
	queue_free()

func _on_attack_frame_changed() -> void:
	if attack_sprite.frame == 7:
		apply_attack_damage()
		attack_effect()

func attack_effect():
	pass
