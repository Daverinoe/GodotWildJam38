shader_type canvas_item;

uniform float phase;

uniform float speed = 2.0;
uniform float x_frequency = 1.2;
uniform float y_frequency = 1.2;
uniform float x_amplitude = 1.5;
uniform float y_amplitude = 1.5;
uniform float inclination = 2.0;

void vertex(){
	VERTEX.y += sin((UV.x - TIME * speed + phase) * y_frequency) * y_amplitude * UV.x;
	VERTEX.x += cos((UV.y - TIME * speed - phase) * x_frequency) * x_amplitude * UV.y;
	VERTEX.x -= UV.y * inclination;
}

void fragment(){
	vec3 sample = texture(TEXTURE, UV).rgb;
	vec3 timeoffset = (cos(TIME + phase) * cos(4.0 * UV.x) * vec3(1.0) * 0.1 + 0.1);
	vec3 shading = smoothstep(0.3, 1.0, UV.y) * vec3(0.5);
	
	vec4 color = vec4(sample + timeoffset - shading, texture(TEXTURE, UV).a);
	COLOR = color;
}