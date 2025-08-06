extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D

var base_energy: float = 0.8
var flicker_timer: float = 0.0

func _ready():
	base_energy = light.energy  
	sprite.play("fire")

func _process(delta):
	flicker_timer += delta 
	var flicker = sin(flicker_timer + randf() * 10.0) * 0.2
	light.energy = base_energy + flicker
	light.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
