extends TileMapLayer

var shader = material as ShaderMaterial

func enable_rain():
	shader.set_shader_parameter("enable_rain", true)

func disable_rain():
	shader.set_shader_parameter("enable_rain", false)
