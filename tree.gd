extends StaticBody2D

var player_in_range = false
var player_overlapped = false
@export var resource_type: String = "log"
@export var amount = 3;
@export_range(0.0, 1.0) var fade_alpha: float = 0.4

func _ready() -> void:
	$Sprite2D.play("idle")
	var mat = $Sprite2D.material
	if mat:
		$Sprite2D.material = mat.duplicate()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		PlayerState.is_gathering = false;
		if player_in_range && PlayerState.has_tool("Axe") and amount > 0:
			PlayerState.is_gathering = true;
			GameManager.curently_gathered = self
			AnimationManager.chop()
			GameManager.player.face_target()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true

func _process(_delta):
	if !GameManager.player:
		return

	var shader_mat := $Sprite2D.material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("fade_enabled", player_overlapped)
		shader_mat.set_shader_parameter("screen_size", get_viewport().get_visible_rect().size)

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
