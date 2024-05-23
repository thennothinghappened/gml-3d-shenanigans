/// @desc 

window_width = window_get_width();
window_height = window_get_height();

var x_lookfrom = cos(look_angle.horizontal) * look_distance;
var y_lookfrom = sin(look_angle.horizontal) * look_distance;

var z_lookfrom = sin(look_angle.vertical) * look_distance;
x_lookfrom *= cos(look_angle.vertical);
y_lookfrom *= cos(look_angle.vertical);

//camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(90, window_width / window_height, 1, 1000));
camera_set_proj_mat(cam, matrix_build_projection_ortho(window_width / 4, window_height / 4, 1, 1000));
camera_set_view_mat(cam, matrix_build_lookat(x_lookfrom, y_lookfrom, z_lookfrom, x, y, z, 0, 0, 1));

camera_apply(cam);


