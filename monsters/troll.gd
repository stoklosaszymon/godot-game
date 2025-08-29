extends "res://unit.gd"

var aoe_radius = 100

func _ready() -> void:
	super._ready()
	hit_frames = [9]

func attack_effect():
	var parent = target.get_parent()
	if parent:
		for unit in parent.get_children():
			if unit == target or unit.team == team:
				continue
			if unit.global_position.distance_to(target.global_position) <= aoe_radius:
				unit.hp -= dmg
