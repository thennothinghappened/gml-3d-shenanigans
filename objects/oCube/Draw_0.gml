/// @desc 

if (vb == undefined) {
	draw_text(x, y, "Loading!!!");
	exit;
}

matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, 0, 1, 1, 1));
vertex_submit(vb, pr_trianglelist, sprite_get_texture(sprite_index, 0));
matrix_set(matrix_world, matrix_identity);
