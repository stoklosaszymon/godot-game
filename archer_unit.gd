extends "res://unit.gd"

var projectile_scene = preload("res://Projectile.tscn")

func fire_at_enemy():
	if is_instance_valid(target):
		var proj = projectile_scene.instantiate()
		get_tree().current_scene.add_child(proj)
		proj.launch(global_position, target, self)

func attack_effect():
	fire_at_enemy()

func apply_attack_damage():
	pass
