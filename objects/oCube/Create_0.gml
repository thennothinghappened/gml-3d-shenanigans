/// @desc 

vb = vertex_create_buffer();

var b = buffer_load("xyzrgb_dragon_with_normals.obj");
text = buffer_read(b, buffer_text);
buffer_delete(b);

var commands = obj_prepare_commands(text);
file = obj_parse_objects(commands);

vertex_begin(vb, vformat_main);

struct_foreach(file.objects, function(name, _) {
	file.write_to_buffer(vb, name);
});

file.destroy();

vertex_end(vb);
vertex_freeze(vb);
