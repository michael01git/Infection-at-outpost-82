shader_type canvas_item;

uniform vec4 Color1 : source_color;
uniform vec4 Color2 : source_color;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	if (input_color == Color1){
		COLOR = Color2;
	}
	if (input_color == Color2){
		COLOR = Color1;
	}
}
