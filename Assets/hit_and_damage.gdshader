shader_type canvas_item;

uniform bool get_attacked;
uniform bool hit_enemy;
uniform vec4 DamageColor : source_color;
uniform vec4 AttackColor : source_color;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);

	if (input_color.a != 0.0){

	if (get_attacked) {
		COLOR = DamageColor;
	}

	if (hit_enemy) {
		COLOR = AttackColor;
	}

	}
}