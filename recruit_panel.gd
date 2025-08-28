extends Control

@export var unit: PackedScene = null
@onready var panel_sprite = $PanelContainer/Control/Unit as AnimatedSprite2D
@export var available_count = 1
@onready var unit_count = $PanelContainer/Control/Available
@onready var unit_cost = $PanelContainer/Control/Cost
@onready var recruit_button = $PanelContainer/Button

var building_id = null;
var cost = 0

func _ready() -> void:
	var unit_instance = unit.instantiate()
	cost = GameManager.unit_costs[unit_instance.name]
	var unit_sprite = unit_instance.get_node("Idle") as AnimatedSprite2D
	if unit_sprite:
		panel_sprite.sprite_frames = unit_sprite.sprite_frames.duplicate()
		panel_sprite.play("S")
	unit_instance.queue_free()
	available_count = GameManager.recruitment_buildings[building_id]

func _process(_delta: float) -> void:
	unit_count.text = "Available: " + str(available_count)
	unit_cost.text = "Cost: " + str(cost)
	if available_count == 0 or PlayerState.resources["gold"] < cost:
		recruit_button.disabled = true
	else:
		recruit_button.disabled = false

func _on_button_pressed() -> void:
	if available_count > 0:
		PlayerState.units.push_back(unit)
		available_count -= 1;
		PlayerState.resources["gold"] -= cost
		GameManager.recruitment_buildings[building_id] = available_count


func _on_close_pressed() -> void:
	queue_free()
