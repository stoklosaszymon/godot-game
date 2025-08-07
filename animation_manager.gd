extends Node

var frames: AnimatedSprite2D = null

var animations = {
	"chop" : load("res://movement/chop.tscn"),
	"mining" : load("res://movement/gathering.tscn"),
	"fishing_cast" : load("res://movement/fishing_cast.tscn"),
	"fishing_idle" : load("res://movement/fishing_idle.tscn"),
	"walk" : load("res://movement/walk.tscn"),
	"torch_walk" : load("res://movement/torch_walk.tscn"),
	"idle" : load("res://movement/idle.tscn"),
	"torch_idle" : load("res://movement/torch_idle.tscn"),
}

func _on_fishing_finished():
	if PlayerState.is_fishing:
		var miss_chance = 0.3
		if randf() > miss_chance:
			GameManager.add_item_to_target(
				ItemManager.get_random_fish().duplicate(),
				PlayerState.inventory
			)
		PlayerState.is_fishing = false

func on_gathering_finished():
	PlayerState.is_gathering = false
	var resource_type = GameManager.curently_gathered.resource_type
	GameManager.add_item_to_target(
		ItemManager.resources[resource_type].duplicate(),
		PlayerState.inventory
	)
	GameManager.curently_gathered.take();

func reset():
	if GameManager.inventory != null:
		GameManager.inventory.open()
		
	AnimationManager.idle()

func fishing():
	PlayerState.is_fishing = true
	var fishing = animations.fishing_cast.instantiate()
	if frames != null:
		frames.sprite_frames = fishing.sprite_frames
		frames.play()

func climb_ladder():
	var walkSprite = load("res://movement/climb_ladder.tscn").instantiate()
	if GameManager.player != null:
		if frames != null:
			frames.sprite_frames = walkSprite.sprite_frames
			PlayerState.is_climbing = true
		frames.play("up")

func gather():
	var gathering = animations.mining.instantiate()
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()

func chop():
	var gathering = animations.chop.instantiate()
	if frames != null:
		frames.sprite_frames = gathering.sprite_frames
		frames.play()

func idle():
	var idleSprite = null
	if PlayerState.equipped_item != null && PlayerState.equipped_item.item_name == "Torch":
		idleSprite = animations.torch_idle.instantiate()
	else:
		idleSprite = animations.idle.instantiate()
	if frames != null:
		frames.sprite_frames = idleSprite.sprite_frames
		frames.play()

func setWalkSprite():
	var walkSprite = null
	walkSprite = animations.walk.instantiate()
	if PlayerState.equipped_item != null && PlayerState.equipped_item.item_name == "Torch":
		walkSprite = animations.torch_walk.tscn.instantiate()

	if frames != null:
		frames.sprite_frames = walkSprite.sprite_frames

func on_finish():
	if PlayerState.is_gathering:
		on_gathering_finished()
	elif PlayerState.is_fishing:
		_on_fishing_finished()
	reset()
