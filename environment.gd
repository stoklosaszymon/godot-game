extends CanvasLayer

@onready var rain : CPUParticles2D = $Rain
@onready var river = $"../Map/River"
@export var day_length := 300.0
@export var min_rain_duration := 60.0
@export var max_rain_events := 2

var day_timer := 0.0
var rain_timer := 0.0
var rain_event_count := 0
var min_time_between_rains = 120.0
var was_raining_recently = false
var time_since_last_rain = 0;
var is_raining := false

func _ready():
	randomize()

func _process(delta):
	day_timer += delta
	if was_raining_recently:
		time_since_last_rain += delta
		
	if time_since_last_rain > min_time_between_rains:
		was_raining_recently = false
		
	if day_timer >= day_length:
		day_timer = 0.0
		rain_event_count = 0

	if is_raining:
		rain_timer -= delta
		if rain_timer <= 0.0:
			_set_rain(false)
	else:
		if rain_event_count < max_rain_events and randf() < delta / 10.0 and !was_raining_recently:
			was_raining_recently = true
			_start_rain()

func _start_rain():
	is_raining = true
	rain_event_count += 1
	rain_timer = min_rain_duration
	_set_rain(true)

func _set_rain(enabled: bool):
	is_raining = enabled
	if is_raining:
		river.enable_rain()
		rain.emitting = true
	else:
		river.disable_rain()
		rain.emitting = false
