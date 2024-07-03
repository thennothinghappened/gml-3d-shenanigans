//
// Simple passthrough fragment shader
//

const float PI = 3.14159;

uniform vec2 u_ViewDirection;

varying vec2 v_TexCoord;
varying vec4 v_Colour;

void main() {
	
	/// The horizon exists at y 0.
	/// 
	/// That means the difference between our viewing angle and 0 represents the inverse of the visiblity of the horizon.
	/// For each pixel on the screen, we can calculate what the viewing angle offset is at that pixel, and the brightness is thus
	/// the difference between that offset, and the position of the horizon from the centre of the screen.
	
	/// The signed, normalized range between [-1, 1] of the view direction.
	vec2 view_direction_normalized = u_ViewDirection / vec2(-PI / 2.0);
	
	/// The vertical difference between the camera centre view position, and the horizon line.
	/// This is a signed value ranging [-1, 1], where a value of 0 represents looking directly at the horizon.
	float camera_horizon_centre_diff = view_direction_normalized.y;
	
	/// The vertical difference between this fragment in the drawn quad, and the horizon, based on the distance to the camera's centrepoint.
	float frag_horizon_centre_diff = abs(1.0 - distance(0.5, v_TexCoord.y - camera_horizon_centre_diff));
	
	gl_FragColor = v_Colour * smoothstep(0.1, 1.0, frag_horizon_centre_diff);
	
    //gl_FragColor = v_Colour * vec4(v_TexCoord.x, v_TexCoord.y * u_ViewDirection.x, u_ViewDirection.y, 1.0);
	
}
