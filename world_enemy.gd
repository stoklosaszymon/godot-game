extends Node2D

@export_enum("S", "SE", "E","NE", "N", "NW","W", "SW") var dir: String = "S"

func _ready() -> void:
	$Idle.play(dir)

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManager.player.mouse_held = false
	SceneTransition.start_battle(self)

func defeat():
	queue_free()
