/// @desc Draw the world.

with (oModel) {
	
	var file = oIoSystem.obj_cache[$ self.filename];
	
	if (file == undefined) {
		continue;
	}
	
	switch (file.build_status) {
		
		case ObjBuildStatus.Building:
			ds_queue_enqueue(other.loading_models, id);
		break;
		
		case ObjBuildStatus.Ready:
			ds_queue_enqueue(other.renderable_models, id);
		break;
		
		default: break;
		
	}
	
}

draw_clear(script_execute_ext(make_color_rgb, self.environment.light_ambient_colour));

self.environment.light_sun_direction[X] = sin(current_time / 1000);
self.environment.light_sun_direction[Y] = sin(current_time / 900);

shader_set(shdVertexLit);
shader_set_uniform_f_array(shader_get_uniform(shdVertexLit, "light_direction"), self.environment.light_sun_direction);
shader_set_uniform_f_array(shader_get_uniform(shdVertexLit, "light_ambient_colour"), self.environment.light_ambient_colour_shader);

while (ds_queue_size(renderable_models) > 0) {
	
	with (ds_queue_dequeue(renderable_models)) {
	
		if (self.vb == undefined) {
			continue;
		}
	
		matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
		vertex_submit(self.vb, pr_trianglelist, sprite_get_texture(self.sprite_index, 0));
		matrix_set(matrix_world, matrix_identity);
	
	}
	
}

shader_reset();

while (ds_queue_size(loading_models) > 0) {
	
	with (ds_queue_dequeue(loading_models)) {
		
		var file = oIoSystem.obj_cache[$ self.filename];
		
		var processed = file.__build_command_index;
		var total = file.__build_command_count;
	
		matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
	
		draw_text(0, 0, $"Loading: {processed}/{total}!!!");
	
		draw_rectangle(0, 20, 200, 40, true);
		draw_rectangle(0, 20, 200 * (processed / total), 40, false);
	
		matrix_set(matrix_world, matrix_identity);
	
	}
}

