extends StaticBody2D

var player_in_range = null
@export var resource_type: String = "log"
@export var amount = 3;

func _ready() -> void:
	$Sprite2D.play("idle")

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		PlayerState.is_gathering = false;
		if player_in_range && PlayerState.equipped_item != null && PlayerState.equipped_item.item_name == "Axe" and amount > 0:
			PlayerState.is_gathering = true;
			GameManager.curently_gathered = self
			PlayerState.chop()
			GameManager.player.face_target(global_position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false

func take():
	amount -= 1
	if amount == 0:
		$Sprite2D.play("cut")
		$Sprite2D.material = null
		GameManager.curently_gathered = null;
		
