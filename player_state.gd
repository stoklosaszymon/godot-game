extends Node

var inventory: Array[ItemData] = [
	preload("res://resources/key.tres"),
];

var equipped_item: ItemData = null:
	set(value):
		if value != null:
			equipped_item = value
			if equipped_item.is_usable:
				equipped_item.use();
