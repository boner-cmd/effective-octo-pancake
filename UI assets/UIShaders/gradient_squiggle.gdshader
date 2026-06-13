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
uniform float fps = 6.0;
uniform sampler2D noise : filter_linear, repeat_enable;
group_uniforms;

varying vec4 modulate;
varying vec2 noise_uv;

group_uniforms GradientScroll;

uniform sampler2D gradient: repeat_enable, filter_nearest;
uniform vec2 gradient_offset = vec2(0.05, 0.05);


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
	vec2 noise_offset = vec2(floor(TIME * fps)) * offset_multiplier;
	float noise_sample = texture(noise, noise_uv + noise_offset).r * 4.0 * PI;
	vec2 direction = vec2(cos(noise_sample), sin(noise_sample));
	vec2 squiggle_uv = UV + direction * strength * 0.005;
	
	vec2 center = vec2(0.5, 0.5);
	float angle = 0.45;
	vec2 rotatedUV = rotateUV(SCREEN_UV, center, angle);
	vec4 gradient_scroll = texture(gradient, rotatedUV + gradient_offset * floor(TIME * fps * 1.0));
	
	vec4 squiggle_texture = texture(TEXTURE, squiggle_uv) * modulate;
	
	COLOR = vec4(gradient_scroll.rgb, squiggle_texture.a);
}