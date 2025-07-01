extends Node

func torch_equiped():
	var item_scene = load("res://resources/torch.tscn").instantiate()
	item_scene.position = Vector2.ZERO
	GameManager.player.add_child(item_scene)
	
func torch_removed():
	GameManager.player.get_node("Torch").queue_free()
