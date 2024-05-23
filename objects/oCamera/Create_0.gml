/// @desc 

cam = camera_create();

look_angle = {
	vertical: 0,
	horizontal: 0
};

look_distance = 10;

mouselock = false;

mouse_look_sensitivity = 0.005;

window_width = window_get_width();
window_height = window_get_height();

surface_resize(application_surface, window_width, window_height);

instance_create_depth(0, 0, 0, oCube);
