extends CharacterBody2D

const SPEED = 50
const STOP_DISTANCE = 4.0 

@onready var _animated_sprite = $Walk
@onready var walk_sprite = $Walk
@onready var torch_sprite = $TorchWalk
@onready var item_marker = $ItemMarker

var mouse_held := false
var target_position := Vector2.ZERO
var with_torch: bool = false

var hand_offsets := {
	"bottom": Vector2(10, -120),
	"bottom-left": Vector2(-33, -113),
	"bottom-right": Vector2(40, -133),
	"left": Vector2(-60, -136),
	"right": Vector2(40, -156),
	"top": Vector2(-30, -183),
	"top-left": Vector2(-56, -156),
	"top-right": Vector2(13, -180),
}

func _init():
	GameManager.player = self

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not get_viewport().gui_get_hovered_control():
				mouse_held = true
			else:
				mouse_held = false
		else:
			mouse_held = false

func _physics_process(delta: float) -> void:
	if mouse_held:
		target_position = get_global_mouse_position()
		var to_target = target_position - global_position

		if to_target.length() > STOP_DISTANCE:
			var direction = to_target.normalized()
			velocity = direction * SPEED
			_play_directional_animation(direction)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if velocity.length() == 0:
		_animated_sprite.stop()


func _play_directional_animation(direction: Vector2) -> void:
	if direction.length_squared() < 0.01:
		_animated_sprite.stop()
		return

	var angle = direction.angle()
	angle = wrapf(angle, -PI, PI)

	var anim_name := ""

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

	if _animated_sprite.animation != anim_name or !_animated_sprite.is_playing():
		_animated_sprite.play(anim_name)
		
	item_marker.position = hand_offsets[anim_name]



func leave_footprint():
	if not is_on_sand(): return  
	var footprint = preload("res://footprint.tscn").instantiate()

	var pos = global_position

	var dir = velocity.normalized()
	if dir.length() == 0:
		return 

	var side = Vector2(-dir.y, dir.x) 

	footprint.global_position = pos
	footprint.rotation = dir.angle() + deg_to_rad(90)
	footprint.scale = Vector2(0.05, 0.05)

	get_parent().add_child(footprint)
	
func is_on_sand() -> bool:
	var tilemap = get_node("../MainMap/Terrain")
	if tilemap:
		var cell = tilemap.local_to_map(global_position)
		var tile_data = tilemap.get_cell_tile_data(cell)
		return tile_data != null and tile_data.get_custom_data("type") == "sand"
	else:
		return false

var last_footprint_time = 0.0
const FOOTPRINT_DELAY = 0.3  

func _process(delta):
	use_walk_sprite()
	if has_node("../MainMap/Terrain") && is_on_sand():
		last_footprint_time += delta
		if last_footprint_time >= FOOTPRINT_DELAY:
			leave_footprint()
			last_footprint_time = 0.0

func equip():
	if PlayerState.equipped_item != null:
		var item_scene = load(PlayerState.equipped_item.resource)
		PlayerState.equiped_item_node = item_scene.instantiate()
		#add_child(PlayerState.equiped_item_node)
		item_marker.add_child(PlayerState.equiped_item_node)
		PlayerState.equiped_item_node.position = Vector2.ZERO
		with_torch = true
	
func unequip():
	if PlayerState.equiped_item_node != null:
		item_marker.remove_child(PlayerState.equiped_item_node)
		with_torch = false
		
func use_walk_sprite() -> void:
	if with_torch:
		walk_sprite.visible = false
		torch_sprite.visible = true
		_animated_sprite = torch_sprite
	else:
		torch_sprite.visible = false
		walk_sprite.visible = true
		_animated_sprite = walk_sprite
