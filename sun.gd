extends Node2D

@onready var sun: DirectionalLight2D = $DirectionalLight2D

const START_ANGLE := -60.0  
const END_ANGLE := 240.0    

@export var day_length: float = 30.0 

var time_passed := 0.0

func _process(delta):
	time_passed += delta

	var t = fmod(time_passed, day_length) / day_length

	var angle_deg = lerp(START_ANGLE, END_ANGLE, t)
	sun.rotation_degrees = angle_deg
	sun.height = lerp(0.2, 0.9, t)
	
	var brightness = clamp(sin(deg_to_rad(angle_deg)), 0.0, 0.5)
	sun.energy = brightness
