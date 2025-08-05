extends CharacterBody2D

@export var speed := 100.0
@export var player_path: NodePath

var player: Node2D

func _ready():
	player = GameManager.player

func _physics_process(delta):
	if not player:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	play_animation(direction)

func play_animation(dir: Vector2):
	if dir.length() == 0:
		$AnimatedSprite2D.stop()
		return

	var angle = dir.angle()
	var anim := ""

	if angle < -2.748 or angle > 2.748:
		anim = "left"
	elif angle < -1.963:
		anim = "top-left"
	elif angle < -1.178:
		anim = "top"
	elif angle < -0.393:
		anim = "top-right"
	elif angle < 0.393:
		anim = "right"
	elif angle < 1.178:
		anim = "bottom-right"
	elif angle < 1.963:
		anim = "bottom"
	else:
		anim = "bottom-left"

	if $AnimatedSprite2D.animation != anim:
		$AnimatedSprite2D.play(anim)
