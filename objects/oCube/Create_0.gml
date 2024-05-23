/// @desc 

vb = vertex_create_buffer();

//sprite_index = sprite_add(get_open_filename("Image|*.png", ""), 0, false, false, 0, 0);
sprite_index = sTest;
var b = buffer_load(get_open_filename("OBJ File|*.obj", ""));
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
