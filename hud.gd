extends CanvasLayer

var is_inventory_open = false
var minimap = "MiniMap"

func _init() -> void:
	if GameManager.hud == null:
		GameManager.hud = self
	else:
		GameManager.hud.queue_free()
		GameManager.hud = self
		
func _ready() -> void:
	$Map.texture = get_parent().get_node("MiniMap").get_texture()

func _on_texture_button_pressed() -> void:
	if GameManager.inventory == null:
		instantiate_inventory()
	else:
		GameManager.inventory.close()

func instantiate_inventory():
	GameManager.inventory = preload("res://inventory.tscn").instantiate()
	add_child(GameManager.inventory)
	
func instantiate_target_inventory():
	GameManager.target_inventory = preload("res://target_inventory.tscn").instantiate()
	add_child(GameManager.target_inventory)

func _on_backpack_mouse_entered() -> void:
	print("mouse over")
	#CursorManager.set_cursor_hand()
