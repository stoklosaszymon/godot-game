extends Camera2D

# --- Zoom Properties ---
var min_zoom := Vector2(0.5, 0.5)
var max_zoom := Vector2(3.0, 3.0)
var zoom_step := 0.2
var zoom_speed := 5.0

var target_zoom := Vector2(1, 1)

# --- Isometric Specific Properties (Adjusted for 64x32 tiles) ---
# For 64x32 tiles, the "height" of the visible diamond is 32 pixels.
# To center the player on the diamond's base, you'll typically offset by half of the tile's height.
# Since the player's origin is usually at their feet (0,0 of their sprite),
# offsetting by -16 (half of 32) will place the player visually on the "top" of the diamond.
# If your player sprite's origin is elsewhere, you might need to adjust this.
var isometric_offset_y := -16 # Half of the tile height (32 / 2)

# Optional: Camera follow speed for smooth movement
var follow_speed := 10.0

func _ready():
	target_zoom = zoom
	#current = true
	# Apply the isometric offset
	offset = Vector2(0, isometric_offset_y)

	# --- Important for Isometric Games ---
	# Set Camera Limits: This is crucial to prevent the camera from showing outside your map.
	# You'll need to calculate these based on your TileMap's size and the camera's zoom.
	# For example, if your TileMap is 100 tiles wide and 100 tiles high:
	# var map_width_pixels = 100 * 64  # Assuming 64px width per tile for x-axis
	# var map_height_pixels = 100 * 32 # Assuming 32px height per tile for y-axis
	# limit_left = 0
	# limit_top = 0
	# limit_right = map_width_pixels
	# limit_bottom = map_height_pixels
	# Note: Camera2D limits are in global coordinates. Your TileMap's `position` matters.
	# Also, `offset` *ignores* camera limits, so the visual center will be offset from the limit.


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = (target_zoom - Vector2(zoom_step, zoom_step)).clamp(min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = (target_zoom + Vector2(zoom_step, zoom_step)).clamp(min_zoom, max_zoom)

func _process(delta):
	# Smoothly interpolate the zoom
	zoom = zoom.move_toward(target_zoom, zoom_speed * delta)

	# If the camera is a separate node and follows a target:
	# var target_node = get_parent() # Or get_node("Player") if player is elsewhere
	# if target_node:
	# 	position = position.move_toward(target_node.position, follow_speed * delta)
