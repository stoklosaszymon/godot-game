extends CharacterBody2D

const SPEED = 250
const STOP_DISTANCE = 4.0
const DIRECTION_SWITCH_THRESHOLD = 0.3

@onready var _animated_sprite = $MovementSprite
@onready var colision = $CollisionShape2D

var mouse_held := false
var target_position := Vector2.ZERO
var anim_name := "bottom"
var last_direction = null
var is_idling: bool = false
var tilemap

@onready var camera = $Camera2D

func _init():
	GameManager.player = self

func _ready():
	tilemap = get_node("../../Map/Terrain")
	AnimationManager.frames = _animated_sprite
	AnimationManager.setWalkSprite()
	_animated_sprite.play(anim_name)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var hovered_control = get_viewport().gui_get_hovered_control()
		mouse_held = event.pressed and (hovered_control == null or hovered_control.name == "TextureRect")

func _physics_process(_delta: float) -> void:
	if mouse_held:
		target_position = get_global_mouse_position()
		var to_target = target_position - global_position
		var direction = to_target.normalized()

		if to_target.length() > STOP_DISTANCE and not PlayerState.is_gathering and not PlayerState.is_fishing:
			_play_directional_animation(direction)
			anim_name = _animated_sprite.animation
			var aligned_direction = get_direction_from_anim(anim_name)
			velocity = aligned_direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if velocity.length() == 0:
		if not is_idling and not PlayerState.is_gathering and not PlayerState.is_fishing:
			is_idling = true
			AnimationManager.idle()
	else:
		is_idling = false
		AnimationManager.setWalkSprite()

func _play_directional_animation(direction: Vector2) -> void:
	if direction.length_squared() < 0.01:
		_animated_sprite.stop()
		return

	if last_direction == null:
		last_direction = direction
	else:
		var angle_change = abs(direction.angle_to(last_direction))
		if angle_change < DIRECTION_SWITCH_THRESHOLD:
			if not _animated_sprite.is_playing():
				_animated_sprite.play(anim_name)
			return
		last_direction = direction

	var angle = direction.angle()
	angle = wrapf(angle, -PI, PI)

	if angle < -7 * PI / 8 or angle >= 7 * PI / 8:
		anim_name = "left"
	elif angle < -5 * PI / 8:
		anim_name = "top-left"
	elif angle < -3 * PI / 8:
		anim_name = "top"
	elif angle < -PI / 8:
		anim_name = "top-right"
	elif angle < PI / 8:
		anim_name = "right"
	elif angle < 3 * PI / 8:
		anim_name = "bottom-right"
	elif angle < 5 * PI / 8:
		anim_name = "bottom"
	elif angle < 7 * PI / 8:
		anim_name = "bottom-left"

	if _animated_sprite.animation != anim_name or not _animated_sprite.is_playing():
		_animated_sprite.play(anim_name)

func get_direction_from_anim(anim: String) -> Vector2:
	match anim:
		"bottom": return Vector2(0, 1)
		"bottom-left": return Vector2(-1, 0.5).normalized()
		"bottom-right": return Vector2(1, 0.5).normalized()
		"left": return Vector2(-1, 0)
		"right": return Vector2(1, 0)
		"top": return Vector2(0, -1)
		"top-left": return Vector2(-1, -0.5).normalized()
		"top-right": return Vector2(1, -0.5).normalized()
		_: return Vector2.ZERO

func leave_footprint():
	if not is_on_sand():
		return
	var footprint = preload("res://footprint.tscn").instantiate()
	var pos = global_position
	var dir = velocity.normalized()
	if dir.length() == 0:
		return
	footprint.global_position = pos
	footprint.rotation = dir.angle() + deg_to_rad(90)
	footprint.scale = Vector2(0.10, 0.10)
	get_parent().add_child(footprint)

func is_on_sand() -> bool:
	var tilemap = tilemap
	if tilemap:
		var cell = tilemap.local_to_map(global_position)
		var tile_data = tilemap.get_cell_tile_data(cell)
		return tile_data != null and tile_data.get_custom_data("type") == "sand"
	else:
		return false

var last_footprint_time = 0.0
const FOOTPRINT_DELAY = 0.3

func _process(delta):
	if has_node("../../Map/Terrain") and is_on_sand():
		last_footprint_time += delta
		if last_footprint_time >= FOOTPRINT_DELAY:
			leave_footprint()
			last_footprint_time = 0.0

func equip():
	if PlayerState.equipped_item != null:
		if PlayerState.equipped_item.unequip_effect:
			ItemManager.call(PlayerState.equipped_item.equip_effect)
	AnimationManager.setWalkSprite()
	AnimationManager.idle()

func unequip():
	if PlayerState.equipped_item.unequip_effect:
		ItemManager.call(PlayerState.equipped_item.unequip_effect)
	PlayerState.equipped_item = null
	AnimationManager.setWalkSprite()
	AnimationManager.idle()

func face_target() -> void:
	var direction = (get_global_mouse_position() - global_position).normalized()
	_play_directional_animation(direction)
	velocity = Vector2.ZERO

func _on_movement_sprite_animation_finished() -> void:
	AnimationManager.on_finish()
