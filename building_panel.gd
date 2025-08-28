extends Control

@onready var slot1 = $PanelContainer/SlotsContainer/Slot
@onready var slot2 = $PanelContainer/SlotsContainer/Slot2
@onready var craft = $PanelContainer/Craft

var input = null
var recipe = null;

func _ready() -> void:
	slot1.connect("item_dropped_on_slot", handle_drop)
	
func close():
	self.queue_free()

func handle_drop(drag_data, item):
	if item.has("source_slot_node"):
		input = item.item_data;
		drag_data.item_data = input
		recipe = CraftingManager.get_recipe(input.item_name)
		if recipe and recipe.output is Resource:
			slot2.item_data = recipe.output
		else:
			slot2.item_data = null
			pass
		
		drag_data.update_visuals()
		slot2.update_visuals()
		can_craft();

func can_craft():
	if PlayerState.inventory.has(slot1.item_data): 
		craft.disabled = false 
	else: 
		craft.disabled = true;

func _on_craft_pressed() -> void:
	GameManager.remove_x_of_item_from_target(slot1.item_data, PlayerState.inventory, 1)
	slot1.update_visuals()
	if recipe != null and recipe.output and recipe.output is Resource:
		GameManager.add_item_to_target(recipe.output.duplicate(), PlayerState.inventory)
	else:
		PlayerState.resources[recipe.output] += recipe.output_quantity
	
	GameManager.inventory.open()
	can_craft()
