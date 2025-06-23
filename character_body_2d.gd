extends CharacterBody2D

const SPEED = 500
const STOP_DISTANCE = 4.0 

@onready var _animated_sprite = $AnimatedSprite2D

var mouse_held := false
var target_position := Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_held = event.pressed 

func _physics_process(delta: float) -> void:
	if mouse_held:
		target_position = get_global_mouse_position()
		var to_target = target_position - global_position

		if to_target.length() > STOP_DISTANCE:
			var direction = to_target.normalized()
			velocity = direction * SPEED

			_animated_sprite.flip_h = direction.x < 0
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if velocity.length() > 0:
		_animated_sprite.play("run")
	else:
		_animated_sprite.stop()
