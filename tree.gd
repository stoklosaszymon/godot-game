extends StaticBody2D

var player_in_range = false
var player_overlapped = false
@export var resource_type: String = "log"
@export var amount = 3;
@export_range(0.0, 1.0) var fade_alpha: float = 0.4

func _ready() -> void:
	$Sprite2D.play("idle")

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		PlayerState.is_gathering = false;
		if player_in_range && PlayerState.equipped_item != null && PlayerState.equipped_item.item_name == "Axe" and amount > 0:
			PlayerState.is_gathering = true;
			GameManager.curently_gathered = self
			AnimationManager.chop()
			GameManager.player.face_target()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true

func _process(delta):
	if not is_instance_valid(GameManager.player):
		return

	var player_behind = GameManager.player.global_position.y < global_position.y
	modulate.a = fade_alpha if player_behind and player_overlapped else 1.0

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false

func take():
	amount -= 1
	if amount == 0:
		$Sprite2D.play("cut")
		$Sprite2D.material = null
		GameManager.curently_gathered = null;

func _on_overlap_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_overlapped = true

func _on_overlap_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_overlapped = false
