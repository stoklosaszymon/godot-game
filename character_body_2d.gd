extends CharacterBody2D

const SPEED = 150
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
			_play_directional_animation(direction)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if velocity.length() == 0:
		_animated_sprite.stop()


func _play_directional_animation(direction: Vector2) -> void:
	var angle = direction.angle()
	angle = wrapf(angle, -PI, PI)  # Ensure angle is within [-PI, PI]

	# Convert angle to direction name
	var anim_name := ""

	if angle < -7 * PI / 8 or angle >= 7 * PI / 8:
		anim_name = "left"
	elif angle < -5 * PI / 8:
		anim_name = "top-left"
	elif angle < -3 * PI / 8:
		anim_name = "top"
	elif angle < -PI / 8:
		anim_name = "top-right"
	elif angle < PI / 8:
		anim_name = "right"
	elif angle < 3 * PI / 8:
		anim_name = "down-right"
	elif angle < 5 * PI / 8:
		anim_name = "down"
	elif angle < 7 * PI / 8:
		anim_name = "down-left"

	if _animated_sprite.animation != anim_name:
		_animated_sprite.play(anim_name)
