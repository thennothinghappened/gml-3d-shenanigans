/// @desc Setup rendering with our camera.

if (activeCamera == undefined) {
	exit;
}

// Render a skybox :)
gpu_set_zwriteenable(false);
draw_set_colour(script_execute_ext(make_color_rgb, environment.light_ambient_colour));
shader_set(shdSkybox);

shader_set_uniform_f_array(shader_get_uniform(shdSkybox, "u_ViewDirection"), [activeCamera.look_angle.horizontal, activeCamera.look_angle.vertical]);

draw_clear(c_black);

draw_primitive_begin(pr_trianglelist);

draw_vertex_texture(0, 0, 0, 0);
draw_vertex_texture(game.window.width, 0, 1, 0);
draw_vertex_texture(0, game.window.height, 0, 1);

draw_vertex_texture(0, game.window.height, 0, 1);
draw_vertex_texture(game.window.width, 0, 1, 0);
draw_vertex_texture(game.window.width, game.window.height, 1, 1);

draw_primitive_end();

shader_reset();
draw_set_colour(c_white);
gpu_set_zwriteenable(true);

// Apply the camera.
activeCamera.apply();
