extends SubViewport

func _ready() -> void:
	var map = get_parent().get_node("Map").duplicate()
	map.modulate = Color(1, 1, 1, 0.5)
	add_child(map)

func _process(delta):
	$Camera2D.position = GameManager.player.position
