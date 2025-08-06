extends Node

var inventory: Array[ItemData] = [
	ItemManager.tools["axe"].duplicate(),
	ItemManager.tools["pole"].duplicate(),
	ItemManager.tools["pickaxe"].duplicate(),
	ItemManager.tools["key"].duplicate(),
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
