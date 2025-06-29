extends Camera2D

# --- Zoom Properties ---
var min_zoom := Vector2(0.5, 0.5)
var max_zoom := Vector2(3.0, 3.0)
var zoom_step := 0.2
var zoom_speed := 5.0

var target_zoom := Vector2(1, 1)

var isometric_offset_y := -16 

var follow_speed := 10.0

func _ready():
	target_zoom = zoom
	offset = Vector2(0, isometric_offset_y)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = (target_zoom - Vector2(zoom_step, zoom_step)).clamp(min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = (target_zoom + Vector2(zoom_step, zoom_step)).clamp(min_zoom, max_zoom)

func _process(delta):
	zoom = zoom.move_toward(target_zoom, zoom_speed * delta)
