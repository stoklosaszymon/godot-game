extends Node

var inventory: Array[ItemData] = [
	preload("res://resources/iron_ore.tres").duplicate()
];

var equipped_item: ItemData = null:
	set(value):
		if value != null:
			equipped_item = value
			if equipped_item.is_usable:
				GameManager.player.equip();
		else:
			equipped_item = null

var is_gathering: bool = false


func setWalkSprite():
	var walkSprite = null
	if equipped_item == null:
		walkSprite = load("res://movement/walk.tscn").instantiate()
	elif equipped_item.item_name == "Torch":
		walkSprite = load("res://movement/torch_walk.tscn").instantiate()
	elif equipped_item.item_name == "Pickaxe":
		walkSprite = load("res://movement/pickaxe_walk.tscn").instantiate()
	elif equipped_item.item_name == "Axe":
		walkSprite = load("res://movement/axe_walk.tscn").instantiate()
		
	if GameManager.player != null:
		var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D

		if frames != null:
			frames.sprite_frames = walkSprite.sprite_frames
	
func gather():
	var gathering = load("res://movement/gathering.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()
