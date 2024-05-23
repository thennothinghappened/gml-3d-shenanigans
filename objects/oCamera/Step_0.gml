/// @desc 

var mouse_move_x = window_mouse_get_delta_x();
var mouse_move_y = window_mouse_get_delta_y();

window_width = window_get_width();
window_height = window_get_height();

if (keyboard_check_pressed(vk_escape)) {
	mouselock = !mouselock;
	window_mouse_set_locked(mouselock);
}

look_angle.horizontal -= mouse_move_x * mouse_look_sensitivity;
look_angle.vertical += mouse_move_y * mouse_look_sensitivity;

look_angle.horizontal = modwrap(look_angle.horizontal, pi * 2);
look_angle.vertical = clamp(look_angle.vertical, -pi/2, pi/2);

look_distance += real(keyboard_check(ord("Q"))) - real(keyboard_check(ord("E")));
look_distance = max(1, look_distance);
