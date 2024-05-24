/// @desc Draw the model!

var file = oIoSystem.obj_cache[$ filename];

if (file != undefined && file.build_status == ObjBuildStatus.Building) {
		
	var processed = file.__build_command_index;
	var total = file.__build_command_count;
		
	draw_text(0, 0, $"Loading: {processed}/{total}!!!");
	
	draw_rectangle(0, 20, 200, 40, true);
	draw_rectangle(0, 20, 200 * (processed / total), 40, false);
	
}

matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, 0, 1, 1, 1));

if (vb != undefined) {
	vertex_submit(vb, pr_trianglelist, sprite_get_texture(sprite_index, 0));
} 

matrix_set(matrix_world, matrix_identity);
