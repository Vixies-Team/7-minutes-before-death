shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float intensity : hint_range(0.0, 1.0) = 0.0;

float random(vec2 uv)
{
	return fract(
		sin(dot(uv, vec2(12.9898, 78.233)))
		* 43758.5453
	);
}

void fragment()
{
	vec2 uv = SCREEN_UV;

	float line = step(
		0.95,
		random(vec2(TIME * 5.0, floor(uv.y * 50.0)))
	);

	if (line > 0.0)
	{
		uv.x += (random(vec2(TIME, uv.y)) - 0.5)
			* 0.1
			* intensity;
	}

	float offset = 0.01 * intensity;

	vec4 r = texture(SCREEN_TEXTURE, uv + vec2(offset, 0.0));
	vec4 g = texture(SCREEN_TEXTURE, uv);
	vec4 b = texture(SCREEN_TEXTURE, uv - vec2(offset, 0.0));

	COLOR = vec4(r.r, g.g, b.b, 1.0);
}