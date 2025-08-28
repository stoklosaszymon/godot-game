extends CanvasLayer

var is_inventory_open = false
var minimap = "MiniMap"
@onready var day = $Time/Day;
@onready var time = $Time/Time
@onready var wood_resource = $Resources/Wood
@onready var gold_resource = $Resources/Gold

func _init() -> void:
	if GameManager.hud == null:
		GameManager.hud = self
	else:
		GameManager.hud.queue_free()
		GameManager.hud = self

func _ready() -> void:
	$Map.texture = get_parent().get_node("MiniMap").get_texture()
	update_resources()

func _process(_delta: float) -> void:
	day.text = str(GameManager.current_day)
	time.text = str(GameManager.current_hour) + ":" + str(GameManager.current_minutes)
	update_resources()

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

func _on_texture_button_mouse_entered() -> void:
	CursorManager.set_cursor_hand()


func _on_texture_button_mouse_exited() -> void:
	CursorManager.set_cursor_arrow()

func update_resources():
	wood_resource.text = "Wood: " + str(PlayerState.resources.wood)
	gold_resource.text = "Gold: " + str(PlayerState.resources.gold)
