extends CharacterBody2D

@onready var loop_timer = $Timer
var state = "idle"

func _ready() -> void:
	play_animation("idle")

func play_animation(animation : String):
	$AnimatedSprite2D.play(animation)

func _on_timer_timeout() -> void:
	if state == "idle":
		play_animation("streching")
		state = "strech"
	else:
		play_animation("idle")
		state = "idle"
