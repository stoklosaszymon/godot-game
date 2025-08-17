extends Node

const TILE_WIDTH := 500
const TILE_HEIGHT := 250

func grid_to_iso(grid: Vector2i) -> Vector2:
	return Vector2(
		float(grid.x - grid.y) * TILE_WIDTH / 2,
		float(grid.x + grid.y) * TILE_HEIGHT / 2
	)

func iso_to_grid(pos: Vector2) -> Vector2i:
	var half_w := TILE_WIDTH / 2.0
	var half_h := TILE_HEIGHT / 2.0

	var x := ((pos.x / half_w) + (pos.y / half_h)) / 2.0
	var y := ((pos.y / half_h) - (pos.x / half_w)) / 2.0

	return Vector2i(round(x), round(y))
