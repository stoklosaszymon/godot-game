shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float speed = 1.0;
uniform vec2 direction = vec2(1.0, 1.0);
uniform float tiling = 0.5;
uniform float blue_threshold = 1.0;
uniform float flow_strength = 0.5;
uniform float distortion_intensity = 1.1;
uniform float noise_scale = 1.0;

void fragment() {
    vec2 flow_dir = normalize(direction);
    vec2 noise_uv = UV * noise_scale;
    float distortion = texture(noise_texture, noise_uv).r;
    vec2 offset = flow_dir * TIME * speed + distortion * distortion_intensity;

    // Safe UVs using epsilon to avoid sampling edges
    vec2 flow_uv = fract(UV * tiling + offset) * 0.998 + 0.001;

    vec4 static_color = texture(TEXTURE, UV);
    vec4 flow_color = texture(TEXTURE, flow_uv);
	
    float blue_amount = static_color.b - max(static_color.r, static_color.g);
    float mask = smoothstep(blue_threshold, blue_threshold, blue_amount);
	
	float brightness = max(flow_color.r, max(flow_color.g, flow_color.b));
	float black_mask = smoothstep(0.05, 0.1, brightness); // Increase to soften edge

	COLOR = mix(static_color, flow_color, mask * flow_strength * black_mask);

	vec3 target_color = vec3(45.0, 111.0, 120.0) / 255.0;
	float tolerance = 0.01;

	if (distance(COLOR.rgb, target_color) < tolerance) {
    	discard;
	}
    //COLOR = mix(static_color, flow_color, mask * flow_strength);
}
