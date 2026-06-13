shader_type canvas_item;

group_uniforms Squiggle;
/**
 * Noise texture scale
 * By default, the noise texture's size in world coordinates is set by its resolution
*/
uniform vec2 scale = vec2(1.0, 1.0);
uniform float strength = .3;
/**
 * Number of squiggle frames per second
*/
uniform float fps = 4.0;
uniform sampler2D noise : filter_linear, repeat_enable;
group_uniforms;

varying vec4 modulate;
varying vec2 noise_uv;

group_uniforms GradientScroll;

uniform sampler2D gradient: repeat_enable, filter_nearest;
uniform vec2 gradient_offset = vec2(0.05, 0.05);

group_uniforms Key;
uniform vec4 replacement_color:source_color;
uniform vec4 key_color:source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform float tolerance : hint_range(0.0, 1.0) = .1;

//function for rotation of gradient texture
vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float s = sin(rotation);
    float c = cos(rotation);
    // Subtract pivot
    uv -= pivot;
    // Apply rotation matrix
    mat2 rotMatrix = mat2(vec2(c, -s), vec2(s, c));
    uv = rotMatrix * uv;
    // Add pivot back
    uv += pivot;
    return uv;
}

void vertex() {
	modulate = COLOR;
	// Use world coordinates for scale-independent squiggles, offset by position to keep pattern attached to object
	noise_uv = (VERTEX - MODEL_MATRIX[3].xy) / (vec2(textureSize(noise, 0)) * scale);
}
// Use irrational constants for unique squiggles every frame
#define offset_multiplier vec2(PI, E)

void fragment() {
	//this is squiggle stuff
	vec2 noise_offset = vec2(floor(TIME * fps)) * offset_multiplier;
	float noise_sample = texture(noise, noise_uv + noise_offset).r * 4.0 * PI;
	vec2 direction = vec2(cos(noise_sample), sin(noise_sample));
	vec2 squiggle_uv = UV + direction * strength * 0.005;
	vec4 squiggle_texture = texture(TEXTURE, squiggle_uv) * modulate;
	
	//this is gradient stuff
	vec2 center = vec2(0.5, 0.5);
	float angle = 0.45;
	vec2 rotatedUV = rotateUV(SCREEN_UV, center, angle);
	vec4 gradient_scroll = texture(gradient, rotatedUV + gradient_offset * floor(TIME * fps * 1.0));
	
	//this is for key
	vec4 tex_color = texture(TEXTURE, squiggle_uv);
	vec3 diff = tex_color.rgb - key_color.rgb;
	float dist = length(diff);
	vec4 result;
	
	
	if (dist < tolerance){
		COLOR = vec4(replacement_color.rgb, squiggle_texture.a * replacement_color.a);
	} else {
		COLOR = vec4(gradient_scroll.rgb, squiggle_texture.a);
	}
}