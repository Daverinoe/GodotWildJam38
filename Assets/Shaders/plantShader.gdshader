// original wind shader from https://github.com/Maujoe/godot-simple-wind-shader-2d/tree/master/assets/maujoe.simple_wind_shader_2d
// original script modified by HungryProton so that the assets are moving differently : https://pastebin.com/VL3AfV8D
//
// speed - The speed of the wind movement.
// minStrength - The minimal strength of the wind movement.
// maxStrength - The maximal strength of the wind movement.
// strengthScale - Scalefactor for the wind strength.
// interval - The time between minimal and maximal strength changes.
// detail - The detail (number of waves) of the wind movement.
// distortion - The strength of geometry distortion.
// heightOffset - The height where the wind begins to move. By default 0.0.

shader_type canvas_item;
render_mode blend_mix;

// Outline shader
uniform float width : hint_range(0.0, 16) = 1.0;
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int pixel_size : hint_range(1, 10) = 4;

// Wind settings.
uniform float speed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0) = 0.05;
uniform float maxStrength : hint_range(0.0, 1.0) = 0.01;
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float heightOffset : hint_range(0.0, 1.0);

// With the offset value, you can if you want different moves for each asset. Just put a random value (1, 2, 3) in the editor. Don't forget to mark the material as unique if you use this
uniform float offset = 0; 


float getWind(vec2 vertex, vec2 uv, float time){
    float diff = pow(maxStrength - minStrength, 2.0);
    float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
    float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
    
    return wind; 
}

void vertex() {
    vec4 pos = WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
    float time = TIME * speed + offset;
    //float time = TIME * speed + pos.x * pos.y  ; not working when moving...
    VERTEX.x += getWind(VERTEX.xy, UV, time);
}

 
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