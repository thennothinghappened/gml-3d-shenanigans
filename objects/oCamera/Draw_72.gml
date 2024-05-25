/// @desc 

self.aspect_ratio = window.aspect_ratio;

var x_lookfrom = cos(look_angle.horizontal) * look_distance;
var y_lookfrom = sin(look_angle.horizontal) * look_distance;

var z_lookfrom = sin(look_angle.vertical) * look_distance;
x_lookfrom *= cos(look_angle.vertical);
y_lookfrom *= cos(look_angle.vertical);

camera_set_proj_mat(self.__gml_camera, matrix_build_projection_perspective_fov(90, self.aspect_ratio, 1, 1000));
camera_set_view_mat(self.__gml_camera, matrix_build_lookat(x_lookfrom + x, y_lookfrom + y, z_lookfrom + z, x, y, z, 0, 0, -1));

camera_apply(self.__gml_camera);

shader_set(shdVertexLit);
shader_set_uniform_f_array(shader_get_uniform(shdVertexLit, "light_direction"), testing_light_dir);

draw_clear(c_red);
