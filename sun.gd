extends Node2D

@onready var sun: DirectionalLight2D = $DirectionalLight2D
@onready var world_environment_node: WorldEnvironment = $"Path/To/Your/WorldEnvironment" # <-- Corrected line

const START_ANGLE := -60.0
const END_ANGLE := 240.0

@export var day_length: float = 30.0

var time_passed := 0.0

const COLOR_NIGHT := Color(0.1, 0.1, 0.2, 1.0)
const COLOR_SUNRISE_SUNSET := Color(0.5, 0.2, 0.1, 1.0)
const COLOR_DAY := Color(0.8, 0.4, 0.5, 1.0)

func _ready():
	sun.rotation_degrees = START_ANGLE

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

	if world_environment_node:
		var environment_resource: Environment = world_environment_node.environment

		if environment_resource:
			environment_resource.ambient_light_energy = brightness * 0.5
			environment_resource.ambient_light_color = sun_color.darkened(0.5).lerp(COLOR_NIGHT, 1.0 - brightness)
