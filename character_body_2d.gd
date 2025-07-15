extends CharacterBody2D

const SPEED = 250
const STOP_DISTANCE = 4.0

@onready var _animated_sprite = $MovementSprite
@onready var colision = $CollisionShape2D

var mouse_held := false
var target_position := Vector2.ZERO
var anim_name := "bottom"
var last_transparent_wall_coords: Vector2i = Vector2i(-1, -1)


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
	
func _ready():
	PlayerState.setWalkSprite()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var hovered_colntrol = get_viewport().gui_get_hovered_control()
			if hovered_colntrol != null:
				mouse_held = get_viewport().gui_get_hovered_control().name == "TextureRect"
			else:
				mouse_held = true
		else:
			mouse_held = false

func _physics_process(delta: float) -> void:
	if mouse_held:
		target_position = get_global_mouse_position()
		var to_target = target_position - global_position

		if to_target.length() > STOP_DISTANCE && !PlayerState.is_gathering && !PlayerState.is_climbing:
			var direction = to_target.normalized()
			velocity = direction * SPEED
			_play_directional_animation(direction)
		else:
			velocity = Vector2.ZERO
	else:
		if PlayerState.is_climbing:
			if PlayerState.is_upladder:
				velocity = Vector2(5.0, 50.0)
			else:
				velocity = Vector2(-5.0, -50.0)
		else:
			velocity = Vector2.ZERO

	move_and_slide()

	if velocity.length() == 0 && !PlayerState.is_gathering && !PlayerState.is_climbing:
		_animated_sprite.stop()

func _play_directional_animation(direction: Vector2) -> void:
	if direction.length_squared() < 0.01:
		_animated_sprite.stop()
		return

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

	if _animated_sprite.animation != anim_name or !_animated_sprite.is_playing():
		_animated_sprite.play(anim_name)
		

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
	footprint.scale = Vector2(0.15, 0.15)

	get_parent().add_child(footprint)
	
func is_on_sand() -> bool:
	var tilemap = get_node("../Map/Terrain")
	if tilemap:
		var cell = tilemap.local_to_map(global_position)
		var tile_data = tilemap.get_cell_tile_data(cell)
		return tile_data != null and tile_data.get_custom_data("type") == "sand"
	else:
		return false

var last_footprint_time = 0.0
const FOOTPRINT_DELAY = 0.3  

func _process(delta):
	if has_node("../Map/Terrain") && is_on_sand():
		last_footprint_time += delta
		if last_footprint_time >= FOOTPRINT_DELAY:
			leave_footprint()
			last_footprint_time = 0.0

func equip():
	if PlayerState.equipped_item != null:
		if PlayerState.equipped_item.unequip_effect:
			ItemManager.call(PlayerState.equipped_item.equip_effect)
			
	PlayerState.setWalkSprite()
	
func unequip():
	if PlayerState.equipped_item.unequip_effect:
		ItemManager.call(PlayerState.equipped_item.unequip_effect)
			
	PlayerState.equipped_item = null
	PlayerState.setWalkSprite()
		
	
func _on_movement_sprite_animation_finished() -> void:
	if PlayerState.is_gathering:
		PlayerState.is_gathering = false
		GameManager.add_item_to_target(
			load("res://resources/iron_ore.tres").duplicate(),
			PlayerState.inventory
		)
		GameManager.curently_gathered.take();
		if GameManager.inventory != null:
			GameManager.inventory.open()
		PlayerState.setWalkSprite()
