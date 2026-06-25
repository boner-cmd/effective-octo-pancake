shader_type canvas_item;

//this shader goes on a copy of a duplicate sprite sibling higher in the tree
//it clips the higher node as a cutout
//if all three nodes are a parent of a BackBufferCopy set in VIEWPORT MODE

group_uniforms Squiggle;
/**
 * Noise texture scale
 * By default, the noise texture's size in world coordinates is set by its resolution
*/
uniform vec2 scale = vec2(1.0, 1.0);
uniform float strength = .4;
/**
 * Number of squiggle frames per second
*/
uniform float fps = 6.0;
uniform sampler2D noise : filter_nearest, repeat_enable;
group_uniforms;

varying vec4 modulate;
varying vec2 noise_uv;

uniform sampler2D screen_texture : hint_screen_texture;

void vertex() {
	modulate = COLOR;
	// Use world coordinates for scale-independent squiggles, offset by position to keep pattern attached to object
	noise_uv = (VERTEX - MODEL_MATRIX[3].xy) / (vec2(textureSize(noise, 0)) * scale);
}

// Use irrational constants for unique squiggles every frame
#define offset_multiplier vec2(PI, E)

void fragment() {
	vec2 noise_offset = vec2(floor(TIME * fps)) * offset_multiplier;
	float noise_sample = texture(noise, noise_uv + noise_offset).r * 4.0 * PI;
	vec2 direction = vec2(cos(noise_sample), sin(noise_sample));
	vec2 squiggle_uv = UV + direction * strength * 0.005;
	
	COLOR = texture(TEXTURE, squiggle_uv) * modulate;
	
	COLOR = texture(screen_texture, SCREEN_UV) * modulate;
	COLOR.a = texture(TEXTURE, squiggle_uv).a;
	
}



