/// @desc 

draw_clear(c_red);

if (vb == undefined) {
	exit;
}

matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
vertex_submit(vb, pr_trianglelist, sprite_get_texture(sprite_index, 0));
matrix_set(matrix_world, matrix_identity);
