extends TextureRect

func _ready() -> void:
	var lifetime = 5.0
	var interval = 1.0
	var elapsed = 0.0
	var unit = get_parent()

	while elapsed < lifetime:
		if unit.get("hp") and is_instance_valid(unit):
			get_parent().hp -= 1
			
		await get_tree().create_timer(interval).timeout
		elapsed += interval

	queue_free()
