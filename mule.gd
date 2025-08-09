extends CharacterBody2D

@export var speed := 240.0
@export var stop_distance := 50.0

const DIRECTION_SWITCH_THRESHOLD = 0.3

var direction: Vector2 = Vector2.ZERO
var player: Node2D
var anim_name := "bottom"
var last_direction: Vector2 = Vector2.ZERO

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func set_target():
	if GameManager.player:
		navigation_agent.target_position = GameManager.player.global_position

func _process(delta):
	if GameManager.player:
		set_target()

func _physics_process(delta):
	var player_distance = global_position.distance_to(player.global_position) if player else INF

	if player_distance <= stop_distance:
		velocity = Vector2.ZERO
		if animated_sprite.is_playing():
			animated_sprite.stop()
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		if animated_sprite.is_playing():
			animated_sprite.stop()
		return

	var next_point = navigation_agent.get_next_path_position()
	direction = (next_point - global_position).normalized()
	
	velocity = direction * speed
	
	_play_directional_animation(direction)
	
	move_and_slide()

func _play_directional_animation(dir: Vector2) -> void:
	if dir.length_squared() < 0.01:
		animated_sprite.stop()
		return
	
	var angle = dir.angle()
	angle = wrapf(angle, -PI, PI)
	
	var new_anim_name = anim_name

	if angle < -7 * PI / 8 or angle >= 7 * PI / 8:
		new_anim_name = "left"
	elif angle < -5 * PI / 8:
		new_anim_name = "top-left"
	elif angle < -3 * PI / 8:
		new_anim_name = "top"
	elif angle < -PI / 8:
		new_anim_name = "top-right"
	elif angle < PI / 8:
		new_anim_name = "right"
	elif angle < 3 * PI / 8:
		new_anim_name = "bottom-right"
	elif angle < 5 * PI / 8:
		new_anim_name = "bottom"
	elif angle < 7 * PI / 8:
		new_anim_name = "bottom-left"

	if new_anim_name != anim_name:
		anim_name = new_anim_name
		animated_sprite.play(anim_name)
	elif not animated_sprite.is_playing():
		animated_sprite.play(anim_name)
