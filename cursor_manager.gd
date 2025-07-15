extends Node

var current_cursor = Input.CURSOR_ARROW
var cursor_lock = preload("res://Assets/UI/cursor_lock.png")
var cursor_openhand = preload("res://Assets/UI/cursor_openhand.png")

func set_cursor_lock():
	Input.set_custom_mouse_cursor(cursor_lock)

func set_cursor_arrow():
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)

func set_cursor_open_hand():
	Input.set_custom_mouse_cursor(cursor_openhand)
	
func set_cursor_hand():
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_POINTING_HAND)
