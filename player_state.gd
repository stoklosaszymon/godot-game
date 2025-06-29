extends Node

var inventory: Array[ItemData] = [
	preload("res://resources/key.tres"),
	preload("res://resources/torch.tres").duplicate()
];

var equipped_item: ItemData = null:
	set(value):
		if value != null:
			equipped_item = value
			if equipped_item.is_usable:
				GameManager.player.equip();

var equiped_item_node:Node = null;
