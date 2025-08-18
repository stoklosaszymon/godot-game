extends Control

@export var unit_scene: PackedScene = preload("res://unit.tscn")
@onready var panel_sprite = $PanelContainer/Control/Unit as AnimatedSprite2D
@export var available_count = 1
@onready var unit_count = $PanelContainer/Control/Label
@onready var recruit_button = $PanelContainer/Button

func _ready() -> void:
	var unit_instance = unit_scene.instantiate()
	var unit_sprite = unit_instance.get_node("Idle") as AnimatedSprite2D
	if unit_sprite:
		panel_sprite.sprite_frames = unit_sprite.sprite_frames.duplicate()
		panel_sprite.play("S")
	unit_instance.queue_free()

func _process(_delta: float) -> void:
	unit_count.text = "Available: " + str(available_count)
	if available_count == 0:
		recruit_button.disabled = true
	else:
		recruit_button.disabled = false

func _on_button_pressed() -> void:
	if available_count > 0:
		PlayerState.units.push_back(unit_scene)
		available_count -= 1;
