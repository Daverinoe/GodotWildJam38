shader_type canvas_item;
render_mode unshaded;

uniform float width : hint_range(0.0, 16) = 1.0;
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int pixel_size : hint_range(1, 10) = 4;
 
void fragment()
{
	vec2 unit = (float(pixel_size) ) / vec2(textureSize(TEXTURE, 0));
	vec4 pixel_color = texture(TEXTURE, UV);
	if (pixel_color.a == 0.0) {
		pixel_color = outline_color;
		pixel_color.a = 0.0;
		for (float x = -ceil(width); x <= ceil(width); x++) {
			for (float y = -ceil(width); y <= ceil(width); y++) {
				if (texture(TEXTURE, UV + vec2(x*unit.x, y*unit.y)).a == 0.0 || (x==0.0 && y==0.0)) {
					continue;
				}
				pixel_color.a = outline_color.a;
				return
			}
		}
	}
	COLOR = pixel_color;
}