extends Node

var fish_data = [
	{ "resource": load("res://resources/fishing/fish1.tres"), "probability": 0.3 },
	{ "resource": load("res://resources/fishing/fish2.tres"), "probability": 0.2 },
	{ "resource": load("res://resources/fishing/fish3.tres"), "probability": 0.15 },
	{ "resource": load("res://resources/fishing/fish4.tres"), "probability": 0.15 },
	{ "resource": load("res://resources/fishing/fish5.tres"), "probability": 0.1 },
	{ "resource": load("res://resources/fishing/fish6.tres"), "probability": 0.05 },
	{ "resource": load("res://resources/fishing/fish7.tres"), "probability": 0.05 },
]

var resources = {
	"iron_ore" : load("res://resources/mining/iron_ore.tres"),
	"gold_ore" : load("res://resources/mining/gold_ore.tres"),
	"coal_ore" : load("res://resources/mining/coal_ore.tres"),
	"ruby_ore" : load("res://resources/mining/ruby_ore.tres"),
	"iron_bar" : load("res://resources/mining/iron_bar.tres"),
	"log" : load("res://resources/wood/log.tres"),
}

var tools = {
	"axe" : load("res://resources/tools/axe.tres"),
	"pickaxe" : load("res://resources/tools/pickaxe.tres"),
	"key" : load("res://resources/tools/key.tres"),
	"pole" : load("res://resources/tools/pole.tres"),
	"torch" : load("res://resources/tools/torch.tres"),
}

func get_random_fish() -> Resource:
	var total_weight = 0.0

	for fish in fish_data:
		total_weight += fish["probability"]

	var roll = randf_range(0.0, total_weight)
	var cumulative = 0.0

	for fish in fish_data:
		cumulative += fish["probability"]
		if roll <= cumulative:
			return fish["resource"]
	return null

func torch_equiped():
	var item_scene =  load("res://resources/tools/torch.tscn").instantiate()
	item_scene.position = Vector2.ZERO
	var sprite_node = item_scene.get_node("AnimatedSprite2D")
	sprite_node.hide()
	GameManager.player.add_child(item_scene)
	
func torch_removed():
	var torch_node = GameManager.player.get_node_or_null("Torch")
	if torch_node:
		torch_node.queue_free()
