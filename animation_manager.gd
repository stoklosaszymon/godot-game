extends Node

func _on_fishing_finished():
	if PlayerState.is_fishing:
		var fishing = load("res://movement/fishing_cast.tscn").instantiate()
		var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D

		GameManager.add_item_to_target(
			load("res://resources/coal_ore.tres").duplicate(),
			PlayerState.inventory
		)
		PlayerState.is_fishing = false

func on_gathering_finished():
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D

	PlayerState.is_gathering = false
	var resource_type = GameManager.curently_gathered.resource_type
	GameManager.add_item_to_target(
		load("res://resources/" + resource_type + ".tres").duplicate(),
		PlayerState.inventory
	)
	GameManager.curently_gathered.take();

func reset():
	if GameManager.inventory != null:
		GameManager.inventory.open()
		
	AnimationManager.idle()

func fishing():
	PlayerState.is_fishing = true
	var fishing = load("res://movement/fishing_cast.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = fishing.sprite_frames
		frames.play()

func climb_ladder():
	var walkSprite = load("res://movement/climb_ladder.tscn").instantiate()
	if GameManager.player != null:
		var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D

		if frames != null:
			frames.sprite_frames = walkSprite.sprite_frames
			PlayerState.is_climbing = true
		frames.play("up")

func gather():
	var gathering = load("res://movement/gathering.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()

func chop():
	var gathering = load("res://movement/chop.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()

func idle():
	var idleSprite = null
	if PlayerState.equipped_item != null && PlayerState.equipped_item.item_name == "Torch":
		idleSprite = load("res://movement/torch_idle.tscn").instantiate()
	else:
		idleSprite = load("res://movement/idle.tscn").instantiate()
	var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D
	if frames != null:
		frames.sprite_frames = idleSprite.sprite_frames
		frames.play()

func setWalkSprite():
	var walkSprite = null
	walkSprite = load("res://movement/walk.tscn").instantiate()
	if PlayerState.equipped_item != null && PlayerState.equipped_item.item_name == "Torch":
		walkSprite = load("res://movement/torch_walk.tscn").instantiate()

	if GameManager.player != null:
		var frames = GameManager.player.get_node("MovementSprite") as AnimatedSprite2D

		if frames != null:
			frames.sprite_frames = walkSprite.sprite_frames

func on_finish():
	if PlayerState.is_gathering:
		on_gathering_finished()
	elif PlayerState.is_fishing:
		_on_fishing_finished()
	reset()
