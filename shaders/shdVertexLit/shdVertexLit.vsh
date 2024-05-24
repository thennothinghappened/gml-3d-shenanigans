/// Vertex-lit shader.

attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 light_direction;

void main() {
	
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	
	float light_intensity = max(dot(normalize(in_Normal), normalize(light_direction)), 0.0);
    
    v_vColour = vec4(in_Colour.rgb * light_intensity, in_Colour.a);
    v_vTexcoord = in_TextureCoord;
	
}
