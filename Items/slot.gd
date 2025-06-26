extends Control

@export var item_data: Item

func _ready():
	if item_data:
		$VBoxContainer/ItemImg.texture = item_data.icon
		$VBoxContainer/ItemName.text = item_data.item_name
