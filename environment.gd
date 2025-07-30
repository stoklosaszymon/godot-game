extends CanvasLayer

@onready var rain : CPUParticles2D = $Rain
@onready var river = $"../Map/River"
@export var day_length := 300.0
@export var min_rain_duration := 30.0
@export var max_rain_events := 3

var day_timer := 0.0
var rain_timer := 0.0
var rain_event_count := 0
var is_raining := false

func _ready():
	randomize()
	_maybe_start_rain()

func _process(delta):
	day_timer += delta
	if day_timer >= day_length:
		day_timer = 0.0
		rain_event_count = 0
		_maybe_start_rain()

	if is_raining:
		rain_timer -= delta
		if rain_timer <= 0.0:
			_set_rain(false)
			_maybe_start_rain()
	else:
		if rain_event_count < max_rain_events and randf() < delta / 10.0:
			_start_rain()

func _start_rain():
	is_raining = true
	rain_event_count += 1
	rain_timer = min_rain_duration
	_set_rain(true)

func _maybe_start_rain():
	if not is_raining and rain_event_count < max_rain_events:
		if randf() < 0.3:  # ~30% chance to start immediately
			_start_rain()

func _set_rain(enabled: bool):
	is_raining = enabled
	if is_raining:
		river.enable_rain()
		rain.emitting = true
	else:
		river.disable_rain()
		rain.emitting = false
