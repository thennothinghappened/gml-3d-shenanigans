/// @desc Instantiate a model from an OBJ file at a random position.

x = random_range(-50, 50);
y = random_range(-50, 50);
z = random_range(-50, 50);

/// @type {Id.VertexBuffer|Undefined} The vertex buffer for this model instance.
vb = undefined;

sprite_index = sTest;

oIoSystem.obj_load_async(filename, function(data, err) {
	
	if (is_instanceof(err, Err)) {
		show_error(err.toString(), true);
	}
	
	self.vb = vertex_create_buffer();
	
	var objects = struct_get_names(data.objects);
	
	for (var i = 0; i < array_length(objects); i ++) {
		
		var object = objects[i];
		data.write_to_buffer(self.vb, object);
		
	}
	
	vertex_freeze(self.vb);
	
});
