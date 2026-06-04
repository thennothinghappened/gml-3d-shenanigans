
/// A camera instance that we can view the world through!
function Camera() constructor {
	/// The internal GM camera.
	self.__gml_camera = camera_create();
	
	self.look_distance = 10;
	
	self.look_angle = {
		vertical: 0,
		horizontal: 0
	};
	
	self.mouselock = false;
	self.mouse_look_sensitivity = 0.005;
	
	self.aspect_ratio = game.window.aspect_ratio;
	
	/// Set this camera's position in 3D space.
	/// 
	/// @param {Real} x
	/// @param {Real} y
	/// @param {Real} z
	static setPosition = function(x, y, z) {
		var x_lookfrom = cos(look_angle.horizontal) * look_distance;
		var y_lookfrom = sin(look_angle.horizontal) * look_distance;
	
		var z_lookfrom = sin(look_angle.vertical) * look_distance;
		x_lookfrom *= cos(look_angle.vertical);
		y_lookfrom *= cos(look_angle.vertical);
		
		camera_set_view_mat(__gml_camera, matrix_build_lookat(x_lookfrom + x, y_lookfrom + y, z_lookfrom + z, x, y, z, 0, 0, -1));
	}
	
	/// Render from this camera's position.
	static apply = function() {
		if (window_mouse_get_locked() != mouselock) {
			window_mouse_set_locked(mouselock);
		}
		
		aspect_ratio = game.window.aspect_ratio;
	
		camera_set_proj_mat(__gml_camera, matrix_build_projection_perspective_fov(90, self.aspect_ratio, 1, 1000));
		camera_apply(__gml_camera);
	}
	
	/// Clean up this camera's data.
	static destroy = function() {
		camera_destroy(__gml_camera);
	}
}
