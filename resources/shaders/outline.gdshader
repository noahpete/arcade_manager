shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec4 col = texture(TEXTURE, UV);

    // Check if the current pixel is transparent
    if (col.a == 0.0) {
        vec2 size = TEXTURE_PIXEL_SIZE * outline_width;

        // Sample neighboring pixels (Up, Down, Left, Right)
        float alpha = texture(TEXTURE, UV + vec2(0.0, size.y)).a;
        alpha += texture(TEXTURE, UV - vec2(0.0, size.y)).a;
        alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
        alpha += texture(TEXTURE, UV - vec2(size.x, 0.0)).a;

        // If any neighbor is solid, draw the outline
        if (alpha > 0.0) {
            COLOR = outline_color;
        } else {
            COLOR = col;
        }
    } else {
        COLOR = col;
    }
}
