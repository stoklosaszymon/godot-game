extends Node2D

var is_open = false

func open():
	$AnimatedSprite2D.play("open")
	$CollisionPolygon2D.set_deferred("disabled", true)

func close():
	$AnimatedSprite2D.play("close")
	$CollisionPolygon2D.set_deferred("disabled", false)
