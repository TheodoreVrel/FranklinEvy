shader_type canvas_item;

uniform vec4 color: source_color;
uniform vec4 color2: source_color;
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 target_color = mix(color, color2, progress);
	COLOR = target_color;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
