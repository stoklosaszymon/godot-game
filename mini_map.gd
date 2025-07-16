extends SubViewport

@onready var player_marker = $"PlayerMarker"

func _ready() -> void:
	var map = get_parent().get_node("Map").duplicate()
	map.modulate = Color(1, 1, 1, 1)
	add_child(map)

func _process(delta: float) -> void:
	player_marker.global_position = GameManager.player.global_position
