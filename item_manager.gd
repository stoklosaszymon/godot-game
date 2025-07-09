extends Node

func torch_equiped():
	var item_scene = await load("res://resources/torch.tscn").instantiate()
	item_scene.position = Vector2.ZERO
	var sprite_node = item_scene.get_node("AnimatedSprite2D")
	sprite_node.hide()
	GameManager.player.add_child(item_scene)
	
func torch_removed():
	GameManager.player.get_node("Torch").queue_free()
