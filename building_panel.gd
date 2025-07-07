extends Control

@onready var slot1 = $PanelContainer/Slot
@onready var slot2 = $PanelContainer/Slot2

var input = null
var output = null;

func _ready() -> void:
	slot1.connect("item_dropped_on_slot", handle_drop)

func handle_drop(drag_data, item):
	if item.has("source_slot_node"):
		input = item.item_data;
		var recipe = CraftingManager.get_recipe(input.item_name)
		if recipe:
			output = load("res://resources/" + CraftingManager.to_resource_name(recipe.output)  + ".tres").duplicate()
			slot2.item_data = output
			drag_data.item_data = item.item_data
			drag_data.update_visuals()
			slot2.update_visuals()
		else:
			pass


func _on_craft_pressed() -> void:
	PlayerState.inventory.erase(slot1.item_data)
	slot1.item_data = null;
	slot2.item_data = null;
	if output != null:
		PlayerState.inventory.append(output)
		output = null
	
	GameManager.inventory.open()
