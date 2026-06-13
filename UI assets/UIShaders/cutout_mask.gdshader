shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture;
//this shader goes on a copy of a duplicate sprite sibling higher in the tree
//it clips the higher node as a cutout
//if all three nodes are a parent of a BackBufferCopy set in VIEWPORT MODE
void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR.a = texture(TEXTURE, UV).a;
}