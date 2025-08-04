extends Node

var inventory: Array[ItemData] = [
	preload("res://resources/iron_ore.tres").duplicate(),
	preload("res://resources/torch.tres").duplicate(),
	preload("res://resources/pickaxe.tres").duplicate(),
	preload("res://resources/axe.tres").duplicate()
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
var is_climbing: bool = false
var is_upladder: bool = false

func setWalkSprite():
	var walkSprite = null
	walkSprite = load("res://movement/walk.tscn").instantiate()
	if equipped_item != null && equipped_item.item_name == "Torch":
		walkSprite = load("res://movement/torch_walk.tscn").instantiate()

	if GameManager.player != null:
		var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D

		if frames != null:
			frames.sprite_frames = walkSprite.sprite_frames

func climb_ladder():
	var walkSprite = load("res://movement/climb_ladder.tscn").instantiate()
	if GameManager.player != null:
		var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D

		if frames != null:
			frames.sprite_frames = walkSprite.sprite_frames
			is_climbing = true
		frames.play("up")

func gather():
	var gathering = load("res://movement/gathering.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()

func chop():
	var gathering = load("res://movement/chop.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()
		
func idle():
	var gathering = load("res://movement/idle.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()
