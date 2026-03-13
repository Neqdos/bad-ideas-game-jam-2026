shader_type canvas_item;

uniform bool is_on = true;

void fragment() {
	if (is_on){
		COLOR.rgb = mix(vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0),  vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), 1.0);
	}
}