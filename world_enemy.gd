extends Node2D

@export_enum("S", "SE", "E","NE", "N", "NW","W", "SW") var dir: String = "S"

@export var units = [
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate()
]

func _ready() -> void:
	$Idle.play(dir)

func _on_area_2d_area_entered(_area: Area2D) -> void:
	GameManager.player.mouse_held = false
	SceneTransition.start_battle(self)

func defeat():
	queue_free()
