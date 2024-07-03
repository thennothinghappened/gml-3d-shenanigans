/// @desc Instantiate a model from an OBJ file at a random position.

x = random_range(-50, 50);
y = random_range(-50, 50);
z = random_range(-50, 50);

/// @type {Id.VertexBuffer|Undefined} The vertex buffer for this model instance.
vb = undefined;

sprite_index = sTest;

/// @instancevar {String} filename
game.ioSystem.objLoadAsync(filename, function(data, err) {
	
	if (is_instanceof(err, Err)) {
		show_error(string(err), true);
	}
	
	var objects = struct_get_names(data.objects);
	vb = vertex_create_buffer();
	
	for (var i = 0; i < array_length(objects); i ++) {
		var object = objects[i];
		data.writeToBuffer(vb, object);
	}
	
	vertex_freeze(vb);
	
});
