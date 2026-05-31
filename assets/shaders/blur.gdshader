shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float blur_strength : hint_range(0.0, 10.0) = 5.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    vec4 col = texture(screen_texture, uv);

    float offset = blur_strength * 0.001;

    col += texture(screen_texture, uv + vec2(offset, 0.0));
    col += texture(screen_texture, uv - vec2(offset, 0.0));
    col += texture(screen_texture, uv + vec2(0.0, offset));
    col += texture(screen_texture, uv - vec2(0.0, offset));

    COLOR = col / 5.0;
}