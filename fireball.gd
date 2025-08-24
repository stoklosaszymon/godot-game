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
