extends Camera2D

@export var zoom_step := 0.05     
@export var min_zoom := 1.0       
@export var max_zoom := 2.0        
@export var drag_speed := 1.5

var dragging := false
var last_mouse_pos := Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if dragging:
				last_mouse_pos = event.position

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = Vector2.ONE * clamp(zoom.x - zoom_step, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = Vector2.ONE * clamp(zoom.x + zoom_step, min_zoom, max_zoom)

	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position -= delta * zoom * drag_speed
		last_mouse_pos = event.position
