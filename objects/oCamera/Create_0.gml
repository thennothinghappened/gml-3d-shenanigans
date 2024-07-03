/// @desc A camera instance that we can view the world through!

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

/// Render from this camera's position.
apply = function() {

	self.aspect_ratio = game.window.aspect_ratio;

	var x_lookfrom = cos(look_angle.horizontal) * look_distance;
	var y_lookfrom = sin(look_angle.horizontal) * look_distance;

	var z_lookfrom = sin(look_angle.vertical) * look_distance;
	x_lookfrom *= cos(look_angle.vertical);
	y_lookfrom *= cos(look_angle.vertical);

	camera_set_proj_mat(self.__gml_camera, matrix_build_projection_perspective_fov(90, self.aspect_ratio, 1, 1000));
	camera_set_view_mat(self.__gml_camera, matrix_build_lookat(x_lookfrom + x, y_lookfrom + y, z_lookfrom + z, x, y, z, 0, 0, -1));

	camera_apply(self.__gml_camera);

}
