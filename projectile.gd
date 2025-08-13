extends Area2D

@export var speed := 700.0              
@export var damage := 10                     

var start_pos: Vector2
var target_pos: Vector2
var travel_time := 0.0
var elapsed := 0.0
var direction: Vector2
var dmg = 5.0
var who_sent: Node2D = null                   

@onready var sprite: Sprite2D = $Sprite2D

func launch(from_pos: Vector2, enemy: Node2D, own: Node2D):
	who_sent = own
	start_pos = from_pos + Vector2(0, -70)
	target_pos = enemy.global_position + Vector2(0, -70)
	position = start_pos

	var distance = (target_pos - start_pos).length()
	travel_time = distance / speed
	elapsed = 0.0

	direction = (target_pos - start_pos).normalized()

func _physics_process(delta: float) -> void:
	elapsed += delta
	var t = clamp(elapsed / travel_time, 0.0, 1.0)
	var ground_pos = start_pos.lerp(target_pos, t)
	position = ground_pos
	sprite.rotation = atan2(direction.y, direction.x)

func is_target_valid(target):
	return is_instance_valid(target) and target.get("hp") and target.get("team")

func _on_body_entered(body: Node) -> void:
	if is_target_valid(body) and is_target_valid(who_sent) and body != who_sent and body.team != who_sent.team:
		body.hp -= dmg
		queue_free()
