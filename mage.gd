extends "res://unit.gd"

var projectile_scene = preload("res://fireball.tscn")

func _ready() -> void:
	super._ready()
	hit_frames = [5]
	
func fire_at_enemy():
	if not is_instance_valid(target) or target.is_dead:
		return
		
	var dist = global_position.distance_to(target.global_position)
	if dist <= attack_range and not is_dead:
		var proj = projectile_scene.instantiate()
		get_tree().current_scene.add_child(proj)
		proj.launch(global_position, target, self, dmg)

func attack_effect():
	fire_at_enemy()

func apply_attack_damage():
	pass

func _on_attack_frame_changed() -> void:
	if attack_sprite.frame in hit_frames and not is_dead:
		fire_at_enemy()
		apply_attack_damage()
