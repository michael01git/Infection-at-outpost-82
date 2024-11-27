shader_type canvas_item;

uniform vec4 Black : source_color;
uniform vec4 White : source_color;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);

	if (input_color == Black){
		COLOR = White;
	}
	if (input_color == White){
		COLOR = Black;
	}
}
