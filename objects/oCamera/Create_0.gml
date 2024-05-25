/// @desc 

self.testing_light_dir = [0, 0.2, 0.5];

self.__gml_camera = camera_create();

self.look_distance = 10;
self.look_angle = {
	vertical: 0,
	horizontal: 0
};

self.mouselock = false;
self.mouse_look_sensitivity = 0.005;

self.aspect_ratio = window.aspect_ratio;
