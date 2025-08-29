extends "res://projectile.gd"

var burning_effect = preload("res://burning_effect.tscn")

func _on_body_entered(body: Node) -> void:
	if is_target_valid(body) and is_target_valid(who_sent) and body != who_sent and body.team != who_sent.team and in_air:
		body.hp -= dmg
		var has_effect_already = body.get_node_or_null("Burning")
		if not has_effect_already:
			var effect = burning_effect.instantiate()
			body.add_child(effect)
		queue_free()

func _physics_process(delta: float) -> void:
	elapsed += delta
	var t = clamp(elapsed / travel_time, 0.0, 1.0)
	var ground_pos = start_pos.lerp(target_pos, t)
	position = ground_pos
	sprite.rotation = atan2(direction.y, direction.x)
	
	if t >= 1.0:
		queue_free()
	
	if not is_target_valid(target) or target.is_dead:
		queue_free()
