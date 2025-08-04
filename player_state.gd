extends Node

var inventory: Array[ItemData] = [
	preload("res://resources/iron_ore.tres").duplicate(),
	preload("res://resources/torch.tres").duplicate(),
	preload("res://resources/pickaxe.tres").duplicate(),
	preload("res://resources/axe.tres").duplicate(),
	preload("res://resources/pole.tres").duplicate()
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
var is_fishing: bool = false
