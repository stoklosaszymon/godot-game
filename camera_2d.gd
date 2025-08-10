extends Camera2D

@export var min_zoom := Vector2(1.0, 1.0)
var max_zoom := Vector2(1.5, 1.5)
var zoom_step := 2.5
var zoom_speed := 5.0
var target_zoom := Vector2(1.0, 1.0)

var isometric_offset_y := -16

func _ready():
	target_zoom = zoom
	offset = Vector2(0, isometric_offset_y)
	position_smoothing_enabled = true
	position_smoothing_speed = 5.0 

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = (target_zoom - Vector2(zoom_step, zoom_step)).clamp(min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = (target_zoom + Vector2(zoom_step, zoom_step)).clamp(min_zoom, max_zoom)

func _process(delta):
	zoom = zoom.move_toward(target_zoom, zoom_speed * delta)
