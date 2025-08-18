extends Node2D

@export_enum("S", "SE", "E","NE", "N", "NW","W", "SW") var dir: String = "S"
@onready var sprite = $Idle
@export var enemy_id = "enemy_id_1"

var units = []

func _ready() -> void:
	units = GameManager.world_enemy_data[enemy_id].duplicate()
	var unit_instance = units[0].instantiate()
	var unit_sprite = unit_instance.get_node("Idle") as AnimatedSprite2D
	if unit_sprite:
		sprite.sprite_frames = unit_sprite.sprite_frames.duplicate()
		sprite.play(dir)
	unit_instance.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		GameManager.player.mouse_held = false
		SceneTransition.start_battle(self)

func defeat():
	queue_free()
