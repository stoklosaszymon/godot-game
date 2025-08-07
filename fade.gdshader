shader_type canvas_item;

uniform bool fade_enabled = false;
uniform vec2 screen_size;
uniform float radius = 48.0;
uniform float softness = 16.0;
uniform float fade_alpha = 0.3;

void fragment() {
	COLOR = texture(TEXTURE, UV);

	if (fade_enabled) {
		vec2 pixel_screen_pos = SCREEN_UV * screen_size;
		vec2 screen_center = screen_size * 0.5;

		float dist = distance(pixel_screen_pos, screen_center);
		float fade = smoothstep(radius, radius - softness, dist);

		COLOR.a *= mix(1.0, fade_alpha, fade);
	}
}