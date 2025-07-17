shader_type canvas_item;

uniform float sway_strength = 5.0; // how much to sway
uniform float sway_speed = 1.5;    // how fast to sway
uniform float sway_frequency = 8.0; // how wavy (segments)

void vertex() {
    float sway = sin(UV.y * sway_frequency + TIME * sway_speed);
    float offset = sway * sway_strength * (1.0 - UV.y);
    VERTEX.x += offset;
}
