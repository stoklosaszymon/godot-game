extends Node2D

@onready var sun: DirectionalLight2D = $DirectionalLight2D
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

const START_ANGLE := -60.0
const END_ANGLE := 240.0

@export var day_length: float = 300.0

var time_passed := 0.0

const COLOR_NIGHT := Color(0.1, 0.1, 0.2, 1.0)
const COLOR_SUNRISE_SUNSET := Color(0.5, 0.2, 0.1, 1.0)
const COLOR_DAY := Color(0.8, 0.4, 0.5, 1.0)

func _ready():
	var start_time_percent := 0.25
	time_passed = day_length * start_time_percent
	var angle_deg = lerp(START_ANGLE, END_ANGLE, start_time_percent)
	sun.rotation_degrees = angle_deg

func _process(delta):
	time_passed += delta

	var t = fmod(time_passed, day_length) / day_length

	var angle_deg = lerp(START_ANGLE, END_ANGLE, t)
	sun.rotation_degrees = angle_deg

	sun.height = lerp(0.2, 0.9, t)

	var normalized_angle_for_brightness = remap(angle_deg, START_ANGLE, END_ANGLE, 0.0, PI)
	var brightness = clamp(sin(normalized_angle_for_brightness), 0.0, 1.0)
	sun.energy = brightness * 1.5

	var sun_color: Color

	if angle_deg < 0:
		var progress = remap(angle_deg, START_ANGLE, 0.0, 0.0, 1.0)
		sun_color = COLOR_NIGHT.lerp(COLOR_SUNRISE_SUNSET, progress)
	elif angle_deg < 90:
		var progress = remap(angle_deg, 0.0, 90.0, 0.0, 1.0)
		sun_color = COLOR_SUNRISE_SUNSET.lerp(COLOR_DAY, progress)
	elif angle_deg < 180:
		var progress = remap(angle_deg, 90.0, 180.0, 0.0, 1.0)
		sun_color = COLOR_DAY.lerp(COLOR_SUNRISE_SUNSET, progress)
	else:
		var progress = remap(angle_deg, 180.0, END_ANGLE, 0.0, 1.0)
		sun_color = COLOR_SUNRISE_SUNSET.lerp(COLOR_NIGHT, progress)

	sun.color = sun_color
	
	if canvas_modulate:
		var modulate_color = COLOR_NIGHT.lerp(Color(1, 1, 1), brightness)
		canvas_modulate.color = modulate_color
