shader_type canvas_item;

uniform float open_amount : hint_range(0.0, 1.0) = 0.0;

void fragment()
{
	vec2 uv = UV;

	float curve =
		0.12 * (1.0 - sin(uv.x * PI));

	float lid_height =
		mix(
			0.55 + curve,
			0.0,
			open_amount
		);

	if (uv.y <= lid_height)
	{
		COLOR = vec4(0.0,0.0,0.0,1.0);
	}
	else
	{
		discard;
	}
}