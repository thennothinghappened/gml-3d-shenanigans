
/// Information about the 3D environment, such as lighting.
/// 
/// @param {Array<Real>} light_sun_direction A vector representing the direction of the sun's lighting.
/// @param {Array<Real>} light_ambient_colour The colour of the ambient environment lighting.
function Environment(
	light_sun_direction,
	light_ambient_colour
) constructor {
	
	self.light_sun_direction = light_sun_direction;
	self.light_ambient_colour = light_ambient_colour;
	
	self.light_ambient_colour_shader = array_map(light_ambient_colour, function(colour) { return colour / 255; });
	
}
