extends Area2D

var player_in_range = null

func _ready():
	set_process_input(true)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		PlayerState.is_gathering = false;
		if player_in_range && PlayerState.equipped_item != null && PlayerState.equipped_item.item_name == "Pickaxe":
			PlayerState.is_gathering = true;
			GameManager.curently_gathered = get_parent()
			AnimationManager.gather()
			GameManager.player.face_target(global_position)

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = body

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = null
