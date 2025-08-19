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
	var start_time_percent = 0.25
	if GameManager.world_time > 0.0:
		time_passed = GameManager.world_time
	else:
		time_passed = day_length * start_time_percent
	var angle_deg = lerp(START_ANGLE, END_ANGLE, start_time_percent)
	sun.rotation_degrees = angle_deg

func _process(delta):
	time_passed += delta
	GameManager.world_time = time_passed
	
	var day_index = int(time_passed / day_length)
	var t = fmod(time_passed, day_length) / day_length
	var hour = int(t * 24.0)
	var minutes = int((t * 24.0 - hour) * 60.0)
	GameManager.update_time(day_index, hour, minutes)

	var angle_deg = lerp(START_ANGLE, END_ANGLE, t)
	sun.rotation_degrees = angle_deg
	sun.height = lerp(0.2, 0.9, t)

	var hour_of_day = t * 24.0
	var brightness: float
	var sun_color: Color

	if hour_of_day < 5.0 or hour_of_day >= 23.0:
		brightness = 0.0
		sun_color = COLOR_NIGHT
	elif hour_of_day < 7.0:
		var progress = (hour_of_day - 5.0) / 2.0
		brightness = progress
		sun_color = COLOR_NIGHT.lerp(COLOR_SUNRISE_SUNSET, progress)
	elif hour_of_day < 18.0:
		brightness = 1.0
		if hour_of_day < 12.0:
			var progress = (hour_of_day - 7.0) / 5.0
			sun_color = COLOR_SUNRISE_SUNSET.lerp(COLOR_DAY, progress)
		else:
			var progress = (hour_of_day - 12.0) / 6.0
			sun_color = COLOR_DAY.lerp(COLOR_SUNRISE_SUNSET, progress)
	else:
		var progress = (hour_of_day - 18.0) / 5.0
		brightness = 1.0 - progress
		sun_color = COLOR_SUNRISE_SUNSET.lerp(COLOR_NIGHT, progress)

	sun.energy = brightness * 1.5
	sun.color = sun_color

	if canvas_modulate:
		var modulate_color = COLOR_NIGHT.lerp(Color(1, 1, 1), brightness)
		canvas_modulate.color = modulate_color

func new_day():
	var keys = GameManager.recruitment_buildings.keys()
	for key in keys:
		GameManager.recruitment_buildings[key] += 1

func hide_sun():
	$DirectionalLight2D.enabled = false
	$CanvasModulate.visible = false
