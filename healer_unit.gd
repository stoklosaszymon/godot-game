extends "res://unit.gd"

var healing_effect = preload("res://Assets/Units/Healer/healing_indicator.png")

func _ready() -> void:
	super._ready()
	hit_frames = [14]

func _process(delta: float) -> void:
	super._process(delta)
	print("team: ", team, " name: ", name, " targeting: ", target)
	

func set_target(skip: Node = null):
	var lowest_ally: Node = null
	var lowest_hp := INF

	for child in get_parent().get_children():
		if not is_valid_target(child, skip):
			continue

		if child.hp < lowest_hp:
			lowest_hp = child.hp
			lowest_ally = child

	if lowest_ally and lowest_ally != target:
		target = lowest_ally
		navigation_agent.target_position = lowest_ally.global_position

func is_valid_target(node: Node, skip: Node) -> bool:
	return (
		is_instance_valid(node)
		and node != skip
		and node.has_method("get")
		and node.get("team") != null
		and node.team == team
		and not node.is_dead
		and node.hp < node.max_hp
	)

func apply_attack_damage():
	if is_instance_valid(target) and not target.is_dead and not is_dead:
		var dist = global_position.distance_to(target.global_position)
		if dist <= attack_range:
			target.hp += dmg
	is_attacking = false


func heal_effect():
	var circle = Sprite2D.new()
	circle.texture = healing_effect
	circle.modulate = Color(0, 1, 0, 0.7)
	circle.scale = Vector2(0.15, 0.15)
	circle.rotation_degrees = 35
	circle.skew = deg_to_rad(23)
	circle.z_index = -1
	target.add_child(circle)

	var tween = create_tween()
	tween.tween_property(circle, "scale", Vector2(0.26, 0.26), 0.5)
	tween.tween_property(circle, "modulate:a", 0.0, 0.5)
	tween.tween_callback(circle.queue_free)


func attack_effect():
	heal_effect()
