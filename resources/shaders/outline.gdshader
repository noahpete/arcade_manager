shader_type canvas_item;

uniform bool enabled = true;
uniform vec4 color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform bool inside = false;
uniform bool add_margins = true;

varying flat vec4 modulate;

void vertex() {
	modulate = COLOR;
	if (enabled && add_margins) {
		VERTEX += (UV * 2.0 - 1.0) * width;
	}
}

bool in_bounds(vec2 uv) {
	return uv == clamp(uv, vec2(0.0), vec2(1.0));
}

bool has_contrary_neighbour(vec2 uv, vec2 pixel_size, sampler2D tex) {
	float w = ceil(width);

	for (float x = -w; x <= w; x++) {
		float dx = clamp(x, -width, width);
		float range = width - abs(dx);

		for (float y = -ceil(range); y <= ceil(range); y++) {
			float dy = clamp(y, -range, range);
			vec2 xy = uv + pixel_size * vec2(dx, dy);

			bool opaque = in_bounds(xy) && texture(tex, xy).a > 0.0;
			if (opaque != inside) {
				return true;
			}
		}
	}
	return false;
}

void fragment() {
	vec2 uv = UV;

	if (enabled && add_margins) {
		vec2 margin_pixel = 1.0 / (1.0 / TEXTURE_PIXEL_SIZE + 2.0 * width);
		uv = (uv - margin_pixel * width) * TEXTURE_PIXEL_SIZE / margin_pixel;
	}

	COLOR = in_bounds(uv) ? texture(TEXTURE, uv) * modulate : vec4(0.0);

	if (enabled && (COLOR.a > 0.0) == inside && has_contrary_neighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		vec4 tint = color * modulate;
		COLOR.rgb = inside ? mix(COLOR.rgb, tint.rgb, tint.a) : tint.rgb;
		COLOR.a += (1.0 - COLOR.a) * tint.a;
	}
}