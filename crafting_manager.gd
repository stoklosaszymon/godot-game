extends Node

var recipes := {
	"iron ore": {
		"output": "iron bar",
		"quantity": 1,
		"input_quantity": 1,
	},
}

func get_recipe(input_item: String) -> Dictionary:
	return recipes.get(input_item, {})
	
func to_resource_name(display_name: String) -> String:
	return display_name.to_lower().replace(" ", "_")
