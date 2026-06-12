shader_type canvas_item;

uniform sampler2D gradient: repeat_enable, filter_nearest;
uniform vec2 offset = vec2(0.1, 0.1);

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

void fragment()
{
	vec2 center = vec2(0.5, 0.5);
	float angle = 0.45;
	vec2 rotatedUV = rotateUV(SCREEN_UV, center, angle);
	
	
	vec4 object_for_alpha = texture(TEXTURE, UV);
	vec4 gradient_scroll = texture(gradient, rotatedUV + offset * TIME);
	vec4 combined;
	combined.rgb = gradient_scroll.rgb;
	combined.a = object_for_alpha.a;
	COLOR = combined;
}
