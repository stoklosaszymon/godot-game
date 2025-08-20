extends Node

var inventory: Array[ItemData] = [
	ItemManager.tools["axe"].duplicate(),
	ItemManager.tools["pole"].duplicate(),
	ItemManager.tools["pickaxe"].duplicate(),
	ItemManager.tools["key"].duplicate(),
];

var units: = [
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://archer_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://squire_unit.tscn").duplicate(),
	load("res://knight_unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
	load("res://unit.tscn").duplicate(),
]

var equipped_item: ItemData = null:
	set(value):
		if value != null:
			equipped_item = value
			if equipped_item.is_usable:
				GameManager.player.equip();
		else:
			equipped_item = null

var is_gathering: bool = false
var is_upladder: bool = false
var is_fishing: bool = false

func has_tool(tool: String):
	return inventory.any(func(item): return item.item_name == tool)
