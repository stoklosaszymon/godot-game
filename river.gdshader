shader_type canvas_item;

uniform sampler2D base_texture;
uniform sampler2D noise_texture;

uniform float time_speed = 0.5;
uniform float distortion_strength = 0.05;
uniform float shimmer_intensity = 0.02;
uniform float shimmer_speed = 3.0;
uniform vec2 flow_direction = vec2(1.0, 0.0);
uniform vec2 noise_scale = vec2(2.0, 2.0);

// Diagonal river shape
uniform float diagonal_width = 0.15;
uniform float diagonal_softness = 0.05;

// Rain control
uniform bool enable_rain = true;
uniform float rain_strength = 0.03; // ripple intensity
uniform int rain_drops = 8;

// Optional UV clamp to avoid edge bleed
uniform vec2 tile_uv_min = vec2(0.05, 0.05);
uniform vec2 tile_uv_max = vec2(0.95, 0.95);

// Simple 2D noise function
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Animate base noise for distortion
    vec2 scroll = flow_direction * TIME * time_speed;
    vec2 noise_uv = UV * noise_scale + scroll;
    vec2 noise_val = texture(noise_texture, noise_uv).rg;

    vec2 distortion = (noise_val - 0.5) * 2.0 * distortion_strength;

    // Optional rain ripples
    if (enable_rain) {
        for (int i = 0; i < rain_drops; i++) {
            // Position along diagonal (x ≈ y)
            float offset = rand(vec2(float(i), 1.0));
            float spread = (rand(vec2(float(i), 2.0)) - 0.5) * 0.1; // deviation
            vec2 drop_pos = vec2(offset + spread, offset - spread);

            float dist = distance(UV, drop_pos);
            float ripple = sin(dist * 100.0 - TIME * 30.0) / (dist * 50.0 + 1.0);

            // Diagonal mask for ripple
            float diag_center = UV.x - UV.y;
            float ripple_mask = 1.0 - smoothstep(diagonal_width, diagonal_width + diagonal_softness, abs(diag_center));

            distortion += normalize(UV - drop_pos) * ripple * rain_strength * ripple_mask;
        }
    }

    // Apply distortion and clamp to safe area
    vec2 final_uv = UV + distortion;
    vec2 clamped_uv = clamp(final_uv, tile_uv_min, tile_uv_max);

    vec4 base_color = texture(base_texture, UV);
    vec4 distorted_color = texture(base_texture, clamped_uv);

    // Optional fallback if sampling hits transparent/black
    if (distorted_color.a < 0.05 || length(distorted_color.rgb) < 0.05) {
        distorted_color = base_color;
    }

    // Add shimmer
    float shimmer = sin((UV.x + UV.y) * 20.0 + TIME * shimmer_speed) * shimmer_intensity;
    distorted_color.rgb += shimmer;

    // Final mask along diagonal river shape
    float diag_center = UV.x - UV.y;
    float diag_mask = 1.0 - smoothstep(diagonal_width, diagonal_width + diagonal_softness, abs(diag_center));

    COLOR = mix(base_color, distorted_color, diag_mask);
}
