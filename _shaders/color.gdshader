shader_type canvas_item;

uniform vec3 color: source_color;
uniform bool enabled = false;

void fragment() {
	if (COLOR.a * float(enabled) > 0.0){
		COLOR.rgb = color;
	}
}
