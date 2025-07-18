extends CharacterBody2D

@onready var loop_timer = $Timer
var state = "idle"

func _ready() -> void:
	play_animation("idle")

func play_animation(animation : String):
	$AnimatedSprite2D.play(animation)

func _on_timer_timeout() -> void:
	if state == "idle":
		loop_timer.wait_time = 20.0
		play_animation("streching")
		state = "strech"
	else:
		loop_timer.wait_time = 4.0
		play_animation("idle")
		state = "idle"
