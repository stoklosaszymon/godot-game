shader_type canvas_item;

uniform sampler2D base_texture;
uniform sampler2D noise_texture;

uniform float time_speed = 0.5;
uniform float distortion_strength = 0.05;
uniform float shimmer_intensity = 0.02;
uniform float shimmer_speed = 3.0;
uniform vec2 flow_direction = vec2(1.0, 0.0);
uniform vec2 noise_scale = vec2(2.0, 2.0);

// Controls the diagonal band of the river
uniform float diagonal_width = 0.15; // Thickness of the diagonal river
uniform float diagonal_softness = 0.05; // Feathering on edges

void fragment() {
    // Animate noise UV
    vec2 scroll = flow_direction * TIME * time_speed;
    vec2 noise_uv = UV * noise_scale + scroll;
    vec2 noise_val = texture(noise_texture, noise_uv).rg;

    // Use RG channels for distortion direction
    vec2 distortion = (noise_val - 0.5) * 2.0 * distortion_strength;
    vec2 final_uv = UV + distortion;

    // Base and distorted color
    vec4 base_color = texture(base_texture, UV);
    vec4 distorted_color = texture(base_texture, final_uv);

    // Add shimmer effect
    float shimmer = sin((UV.x + UV.y) * 20.0 + TIME * shimmer_speed) * shimmer_intensity;
    distorted_color.rgb += shimmer;

    // Diagonal mask logic
    float diag_center = UV.x - UV.y; // Diagonal line (UV.x == UV.y)
    float diag_mask = 1.0 - smoothstep(diagonal_width, diagonal_width + diagonal_softness, abs(diag_center));

    // Blend effect based on mask
    COLOR = mix(base_color, distorted_color, diag_mask);
}
