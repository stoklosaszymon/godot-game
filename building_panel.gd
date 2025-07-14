extends Control

@onready var slot1 = $PanelContainer/Slot
@onready var slot2 = $PanelContainer/Slot2
@onready var craft = $PanelContainer/Craft

var input = null
var output = null;

func _ready() -> void:
	slot1.connect("item_dropped_on_slot", handle_drop)
	
func close():
	self.queue_free()

func handle_drop(drag_data, item):
	if item.has("source_slot_node"):
		input = item.item_data;
		var recipe = CraftingManager.get_recipe(input.item_name)
		if recipe:
			output = load("res://resources/" + CraftingManager.to_resource_name(recipe.output)  + ".tres")
			slot2.item_data = output
			drag_data.item_data = item.item_data
			drag_data.update_visuals()
			slot2.update_visuals()
			can_craft();
		else:
			pass

func can_craft():
	if PlayerState.inventory.has(slot1.item_data): 
		craft.disabled = false 
	else: 
		craft.disabled = true;

func _on_craft_pressed() -> void:
	GameManager.remove_x_of_item_from_target(slot1.item_data, PlayerState.inventory, 1)
	slot1.update_visuals()
	if output != null:
		GameManager.add_item_to_target(output.duplicate(), PlayerState.inventory)
	
	GameManager.inventory.open()
	can_craft()
