extends CharacterBody2D

@export var team: String = ""
@export var hp: int = 15
@export var dmg: int = 5
@export var attack_range: float = 200.0  
@export var speed: float = 200.0        
@export var separation_strength: float = 100.0 
@export var separation_distance: float = 100.0
@export var stuck_time_limit: float = 2.0     
@export var stuck_distance_threshold: float = 1.0

const TILE_WIDTH := 500
const TILE_HEIGHT := 250
var hit_frames := [7]

@onready var walk_sprite: AnimatedSprite2D = $Walk
@onready var attack_sprite: AnimatedSprite2D = $Attack
@onready var idle_sprite: AnimatedSprite2D = $Idle
@onready var death_sprite: AnimatedSprite2D = $Death
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hp_label: Label = $HP

var max_hp := 0
var target: Node = null
var is_attacking := false
var is_dead := false
var direction: Vector2 = Vector2.ZERO
var last_dir_name := "S"
var direction_change_timer := 0.0
var last_position: Vector2
var stuck_timer: float = 0.0

var original_scene: PackedScene = null

func _ready():
	max_hp = hp
	last_position = global_position
	setup_navigation()
	setup_collision()
	set_closest_enemy_target()

func setup_navigation():
	navigation_agent.avoidance_enabled = true
	navigation_agent.radius = 100
	navigation_agent.max_neighbors = 10
	navigation_agent.time_horizon = 1.0

func setup_collision():
	if team == "player":
		set_collision_mask_value(3, true)
		set_collision_layer_value(3, true)
	elif team == "enemy":
		set_collision_mask_value(2, true)
		set_collision_layer_value(2, true)


func _process(_delta: float) -> void:
	if is_dead: return
	if hp <= 0: die()

	update_ui()
	validate_target()
	set_closest_enemy_target()


func _physics_process(delta: float) -> void:
	if is_dead: return
	if target == null: 
		update_idle_animation()
		return

	var dist = global_position.distance_to(target.global_position)
	
	if dist <= attack_range:
		start_attack()
	else:
		move_towards_target(delta)

	if !is_attacking:
		check_if_stuck(delta)


func validate_target():
	if not is_instance_valid(target) or target.is_dead:
		target = null
		set_closest_enemy_target()

func set_closest_enemy_target(skip: Node = null):
	var closest_enemy: Node = null
	var closest_dist := INF

	for child in get_parent().get_children():
		if not is_valid_enemy(child, skip):
			continue

		var dist = global_position.distance_to(child.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = child

	if closest_enemy and closest_enemy != target:
		target = closest_enemy
		navigation_agent.target_position = find_attack_position()


func is_valid_enemy(node: Node, skip: Node) -> bool:
	return (
		node != self
		and is_instance_valid(node)
		and node != skip
		and node.has_method("get") 
		and node.get("team") != null
		and node.team != team
		and not node.is_dead
	)


func move_towards_target(_delta: float) -> void:
	is_attacking = false
	navigation_agent.target_position = find_attack_position()
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next_path = navigation_agent.get_next_path_position()
		var move_dir = (next_path - global_position).normalized()
		move_dir += separate_from_allies() * (separation_strength / speed)
		move_dir = eight_dir_snap(move_dir.normalized())

		velocity = move_dir * speed
		move_and_slide()
		direction = velocity.normalized()
		update_walk_animation_with_direction(direction)


func check_if_stuck(delta: float):
	var movement = global_position.distance_to(last_position)
	last_position = global_position
	stuck_timer = stuck_timer + delta if (movement < stuck_distance_threshold) else 0.0
	
	if stuck_timer >= stuck_time_limit:
		stuck_timer = 0.0
		set_closest_enemy_target(target)


func find_attack_position() -> Vector2:
	if not is_instance_valid(target): return global_position
	var dir = (target.global_position - global_position).normalized()
	var offset = dir.rotated(randf_range(-PI / 4, PI / 4)) * 30
	return target.global_position - dir * (attack_range * 0.8) + offset


func separate_from_allies() -> Vector2:
	var push = Vector2.ZERO
	for ally in get_parent().get_children():
		if ally == self or not is_instance_valid(ally) or ally.team != team:
			continue
		var to_self = global_position - ally.global_position
		var dist = to_self.length()
		if dist > 0 and dist < separation_distance:
			push += to_self.normalized() * ((separation_distance - dist) / separation_distance)
	return push.normalized()


func start_attack():
	velocity = Vector2.ZERO
	if !is_attacking:
		direction = (target.global_position - global_position).normalized()
		direction = eight_dir_snap(direction)
	is_attacking = true
	update_attack_animation()

func apply_attack_damage():
	if is_instance_valid(target) and not target.is_dead:
		var dist = global_position.distance_to(target.global_position)
		if dist <= attack_range:
			target.hp -= dmg
	is_attacking = false


func die():
	is_dead = true
	target = null
	update_death_animation()
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	#queue_free()


func update_ui():
	hp_label.text = str(hp) + "/" + str(max_hp)


func update_walk_animation_with_direction(world_dir: Vector2) -> void:
	if world_dir == Vector2.ZERO: return
	var dir_name = get_direction_name(world_dir)
	if dir_name != last_dir_name:
		direction_change_timer += get_physics_process_delta_time()
		if direction_change_timer >= 0.1:
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
	last_dir_name = get_direction_name(direction)
	walk_sprite.hide()
	idle_sprite.hide()
	attack_sprite.show()
	if attack_sprite.animation != last_dir_name or not attack_sprite.is_playing():
		attack_sprite.play(last_dir_name)


func update_death_animation():
	idle_sprite.hide()
	attack_sprite.hide()
	walk_sprite.hide()
	death_sprite.show()
	if death_sprite.animation != last_dir_name or not death_sprite.is_playing():
		death_sprite.play(last_dir_name)


func eight_dir_snap(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO: return Vector2.ZERO
	var angle_step = PI / 4
	var snapped_angle = round(dir.angle() / angle_step) * angle_step
	return Vector2.RIGHT.rotated(snapped_angle).normalized()


func get_direction_name(dir: Vector2) -> String:
	if dir == Vector2.ZERO: return last_dir_name
	var degrees = rad_to_deg(dir.angle())
	if degrees < 0: degrees += 360
	if degrees < 22.5 or degrees >= 337.5: return "E"
	elif degrees < 67.5: return "SE"
	elif degrees < 112.5: return "S"
	elif degrees < 157.5: return "SW"
	elif degrees < 202.5: return "W"
	elif degrees < 247.5: return "NW"
	elif degrees < 292.5: return "N"
	else: return "NE"


func _on_attack_animation_finished() -> void:
	is_attacking = false


func _on_attack_frame_changed() -> void:
	if attack_sprite and attack_sprite.frame in hit_frames:
		apply_attack_damage()
		attack_effect()


func attack_effect():
	pass
