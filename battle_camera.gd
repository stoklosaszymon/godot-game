extends Camera2D

@export var zoom_step := 0.05     
@export var min_zoom := 1.0       
@export var max_zoom := 2.0        
@export var drag_speed := 1.5

var dragging := false
var last_mouse_pos := Vector2.ZERO
