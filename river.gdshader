shader_type canvas_item;

uniform float speed = 1.0;
uniform vec2 direction = vec2(1.0, 1.0);
uniform float tiling = 1.0;
uniform float blue_threshold = 0.03; // How blue it needs to be to move

void fragment() {
    // UVs for flowing texture
    vec2 flow_uv = fract(UV * tiling + TIME * speed * direction);

    // Static color
    vec4 static_color = texture(TEXTURE, UV);

    // Flowing color
    vec4 flow_color = texture(TEXTURE, flow_uv);

    // Create a mask: high when pixel is mostly blue
    float blue_amount = static_color.b - max(static_color.r, static_color.g);
    float mask = smoothstep(blue_threshold, blue_threshold + 0.1, blue_amount);

    // Blend between static and flowing based on mask
    COLOR = mix(static_color, flow_color, mask);
}
