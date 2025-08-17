extends "res://unit.gd"

var projectile_scene = preload("res://Projectile.tscn")

func _ready() -> void:
	super._ready()
	hit_frames = [5]
	
func fire_at_enemy():
	if is_instance_valid(target):
		var proj = projectile_scene.instantiate()
		get_tree().current_scene.add_child(proj)
		proj.launch(global_position, target, self)

func attack_effect():
	fire_at_enemy()

func apply_attack_damage():
	pass

func _on_attack_frame_changed() -> void:
	if attack_sprite.frame in hit_frames:
		fire_at_enemy()
