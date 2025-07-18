extends SubViewport

@onready var player_marker = $"PlayerMarker"

func _ready() -> void:
	var map = get_parent().get_node("Map").duplicate()
	map.modulate = Color(1, 1, 1, 1)
	add_child(map)

func _process(_delta: float) -> void:
	var offset = Vector2(0.0, -350.0)
	player_marker.global_position = GameManager.player.global_position
	player_marker.global_position += offset
