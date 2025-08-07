extends StaticBody2D

@export var amount = 3;
@export var resource_type: String = "iron_ore"
@onready var texture_rect: Sprite2D = $TextureRect
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var light: PointLight2D = $PointLight2D

func _ready():
	if resource_type in GameManager.resource_textures:
		texture_rect.texture = GameManager.resource_textures[resource_type]
		
	if resource_color_map.has(resource_type):
		particles.color = resource_color_map[resource_type]
		light.color = resource_color_map[resource_type]
	else:
		particles.emitting = false
		light.enabled = false

func _process(_delta: float) -> void:
	if amount == 0:
		GameManager.curently_gathered = null;
		queue_free()

func take():
	amount -= 1;
	
var resource_color_map := {
	"gold_ore": Color(1.0, 0.84, 0.0),   
	"ruby_ore": Color(1.0, 0.07, 0.0) 
}
