/// @desc Draw the world.

if (activeCamera == undefined) {
	exit;
}

environment.light_sun_direction[X] = sin(current_time / 1000);
environment.light_sun_direction[Y] = sin(current_time / 900);

shader_set(shdVertexLit);
shader_set_uniform_f_array(shader_get_uniform(shdVertexLit, "light_direction"), environment.light_sun_direction);
shader_set_uniform_f_array(shader_get_uniform(shdVertexLit, "light_ambient_colour"), environment.light_ambient_colour_shader);

with (oModel) {
	if (self.vb == undefined) {
		continue;
	}

	matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
	vertex_submit(self.vb, pr_trianglelist, sprite_get_texture(self.sprite_index, 0));
	matrix_set(matrix_world, matrix_identity);
}

shader_reset();

with (oModel) {
	if (self.vb != undefined) {
		continue;
	}
	
	var file = game.modelManager.objCache[$ self.filename];
		
	var processed = file.__build_command_index;
	var total = file.__build_command_count;

	matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));

	draw_text(0, 0, $"Loading: {processed}/{total}!!!");

	draw_rectangle(0, 20, 200, 40, true);
	draw_rectangle(0, 20, 200 * (processed / total), 40, false);

	matrix_set(matrix_world, matrix_identity);
}
