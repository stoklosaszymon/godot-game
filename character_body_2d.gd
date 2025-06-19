extends CharacterBody2D

const SPEED = 30

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir:
		_animated_sprite.play("run")
	else:
		_animated_sprite.stop()
		
	if self.velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = direction * SPEED
	else:
		self.velocity = Vector2.ZERO
	move_and_slide()
