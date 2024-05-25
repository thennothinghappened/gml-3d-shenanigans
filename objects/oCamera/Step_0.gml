/// @desc 

var forward_backward_input = real(keyboard_check(ord("W"))) - real(keyboard_check(ord("S")));
var left_right_input = real(keyboard_check(ord("D"))) - real(keyboard_check(ord("A")));
var mouse_move_x = window_mouse_get_delta_x();
var mouse_move_y = window_mouse_get_delta_y();

window_width = window_get_width();
window_height = window_get_height();

if (keyboard_check_pressed(vk_escape)) {
	mouselock = !mouselock;
	window_mouse_set_locked(mouselock);
}

if (keyboard_check_pressed(ord("L"))) {
	
	var filename = get_open_filename("OBJ File|*.obj", "");
	
	if (filename != "") {
		instance_create_depth(0, 0, 0, oModel, {
			filename
		});
	}
	
}

look_angle.horizontal -= mouse_move_x * mouse_look_sensitivity;
look_angle.vertical += mouse_move_y * mouse_look_sensitivity;

look_angle.horizontal = modwrap(look_angle.horizontal, pi * 2);
look_angle.vertical = clamp(look_angle.vertical, -pi/2 + 0.01, pi/2 - 0.01);

look_distance += real(keyboard_check(ord("Q"))) - real(keyboard_check(ord("E")));
look_distance = max(1, look_distance);

var x_lookfrom = cos(look_angle.horizontal);
var y_lookfrom = sin(look_angle.horizontal);

var z_lookfrom = sin(look_angle.vertical);
x_lookfrom *= cos(look_angle.vertical);
y_lookfrom *= cos(look_angle.vertical);

x -= x_lookfrom * forward_backward_input;
y -= y_lookfrom * forward_backward_input;
z -= z_lookfrom * forward_backward_input;

x -= left_right_input * cos(look_angle.horizontal - (pi / 2));
y -= left_right_input * sin(look_angle.horizontal - (pi / 2));

z += real(keyboard_check(vk_space)) - real(keyboard_check(vk_shift));
