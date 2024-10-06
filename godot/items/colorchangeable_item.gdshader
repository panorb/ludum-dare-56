shader_type canvas_item;

uniform vec3 target_color_a;
uniform vec3 new_color_a;

uniform vec3 target_color_b;
uniform vec3 new_color_b;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 handle_color_switch(vec3 target_color, vec4 current_texture, vec3 new_color_on_switch, vec4 color){
	if(current_texture.x == target_color.x
		&& current_texture.y == target_color.y 
		&& current_texture.z == target_color.z){
		return vec4(new_color_on_switch.x, 
		new_color_on_switch.y,
		new_color_on_switch.z, 
		current_texture.w);
	}
	
	return color;
}

void fragment() {
	vec4 current = texture(TEXTURE,UV);
	COLOR = handle_color_switch(target_color_a, current, new_color_a, COLOR);
	COLOR = handle_color_switch(target_color_b, current, new_color_b, COLOR);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
