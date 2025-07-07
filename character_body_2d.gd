extends CharacterBody2D

const SPEED = 180
const STOP_DISTANCE = 4.0

@onready var _animated_sprite = $MovementSprite

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

		if to_target.length() > STOP_DISTANCE && !PlayerState.is_gathering:
			var direction = to_target.normalized()
			velocity = direction * SPEED
			_play_directional_animation(direction)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if velocity.length() == 0 && !PlayerState.is_gathering:
		_animated_sprite.stop()

	var wall_tilemap = get_node_or_null("../Ground/Wall1")
	if not wall_tilemap:
		return

	var player_map_coords: Vector2i = GameManager.player.global_position + Vector2(0, 70)
	var current_wall_tile_coords: Vector2i = wall_tilemap.local_to_map(wall_tilemap.to_local(player_map_coords))

	if current_wall_tile_coords != last_transparent_wall_coords:
		if last_transparent_wall_coords != Vector2i(-1, -1):
			_apply_alpha_to_tile(wall_tilemap, last_transparent_wall_coords, 1.0)
			
		_apply_alpha_to_tile(wall_tilemap, current_wall_tile_coords, 0.4)
		
		last_transparent_wall_coords = current_wall_tile_coords

func _apply_alpha_to_tile(tile_map, coords: Vector2i, alpha: float) -> void:
	var tile_data: TileData = tile_map.get_cell_tile_data(coords)
	
	if tile_data:
		tile_data.modulate = Color(1.0, 1.0, 1.0, alpha)
		var source_id = tile_map.get_cell_source_id(coords)
		var atlas_coords = tile_map.get_cell_atlas_coords(coords)
		tile_map.set_cell(coords, source_id, atlas_coords, 0)
	
		if alpha == 0.4:
			GameManager.player._animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.4)
		elif alpha == 1.0:
			GameManager.player._animated_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

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
	if has_node("../MainMap/Terrain") && is_on_sand():
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
		PlayerState.inventory.append(
			load("res://resources/iron_ore.tres")
		)
		GameManager.curently_gathered.take();
		if GameManager.inventory != null:
			GameManager.inventory.open()
		PlayerState.setWalkSprite()
