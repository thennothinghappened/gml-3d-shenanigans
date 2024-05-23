
/// Prepare an OBJ file's command list to be parsed.
/// 
/// @param {String} text
/// @returns {Array<Array<String>>}
function obj_prepare_commands(text) {

	var split = string_split(text, "\n", true);
	
	var decommented = array_map(split, function(line) {
		
		var comment_begin = string_pos("#", line);
		
		if (comment_begin < 1) {
			return line;
		}
		
		return string_copy(line, 1, comment_begin - 1);
		
	});
	
	var trimmed = array_map(decommented, function(line) {
		return string_trim(line);
	});
	
	var lines = array_filter(trimmed, function(line) {
		return string_length(line) > 0;
	});
	
	/// Feather ignore GM1045
	return array_map(lines, function(line) {

		var split = string_split(line, " ");
		
		if (array_length(split) < 1) {
			throw $"Failed to parse OBJ command - Invalid command `{line}`!";
		}
		
		return split;
		
	});
	
}

/// Parse a list of OBJ file commands into an object list.
/// 
/// @param {Array<Array<String>>} commands
/// @returns {Struct.ObjFile}
function obj_parse_objects(commands) {
	
	var file = new ObjFile();
	var current = "default_object";
	
	for (var i = 0; i < array_length(commands); i ++) {
		
		var cmd = commands[i];
		var type = array_shift(cmd);
		
		switch (type) {
			
			case "o": {
				
				current = cmd[0];
				break;
			}
			
			case "s": {
				
				file.smooth_shading = bool(real(cmd[0]));
				break;
				
			}
			
			case "v": {
				
				file.vertex(real(cmd[X]), real(cmd[Y]), real(cmd[Z]));
				break;
				
			}
			
			case "vt": {
				
				file.texcoord(real(cmd[X]), real(cmd[Y]));
				break;
				
			}
			
			case "vn": {
				
				file.normal(real(cmd[X]), real(cmd[Y]), real(cmd[Z]));
				break;
				
			}
			
			case "f": {
				
				file.face_parse_command(current, cmd);
				break;
				
			}
			
			case "usemtl":
			case "mtllib": {
				
				show_debug_message("TODO: MTL support");
				break;
				
			}
			
			default: {
				throw $"Unknown/Unsupported command type `{type}` in command `{cmd}`";
			}
		}
		
	}
	
	return file;
	
}

/// An OBJ file that contains objects.
/// 
/// @param {Bool} smooth_shading
function ObjFile(smooth_shading = false) constructor {
	
	enum ObjFaceComponent {
		Vertex		= 0,
		TexCoord	= 1,
		Normal		= 2,
	}
	
	self.verts = buffer_create(0, buffer_grow, 1);
	self.texcoords = buffer_create(0, buffer_grow, 1);
	self.normals = buffer_create(0, buffer_grow, 1);
	self.smooth_shading = smooth_shading;
	
	self.objects = {};
	
	/// Append a vertex.
	/// 
	/// @param {Real} x
	/// @param {Real} y
	/// @param {Real} z
	static vertex = function(x, y, z) {
		buffer_write(self.verts, buffer_f32, x);
		buffer_write(self.verts, buffer_f32, y);
		buffer_write(self.verts, buffer_f32, z);
	}
	
	/// Append a texture coordinate.
	/// 
	/// @param {Real} x
	/// @param {Real} y
	static texcoord = function(x, y) {
		buffer_write(self.texcoords, buffer_f32, x);
		buffer_write(self.texcoords, buffer_f32, y);
	}
	
	/// Append a vertex normal direction.
	/// 
	/// @param {Real} x
	/// @param {Real} y
	/// @param {Real} z
	static normal = function(x, y, z) {
		buffer_write(self.normals, buffer_f32, x);
		buffer_write(self.normals, buffer_f32, y);
		buffer_write(self.normals, buffer_f32, z);
	}
	
	/// Read the passed face command and append the face.
	/// 
	/// Throws if the command is malformed.
	/// 
	/// @param {String} name The object to append the face to.
	/// @param {Array<String>} cmd
	static face_parse_command = function(name, cmd) {
		
		if (array_length(cmd) != 3) {
			throw $"Invalid face command `{cmd}` - must have three components.";
		}
		
		if (!struct_exists(self.objects, name)) {
			self.objects[$ name] = buffer_create(0, buffer_grow, 1);
		}
		
		var object = self.objects[$ name];
		
		try {
			
			for (var i = 0; i < 3; i ++) {
				
				var point = string_split(cmd[i], "/", false, 3);
				var length = array_length(point);
				var vertex_index = real(point[ObjFaceComponent.Vertex]);
				
				buffer_write(object, buffer_u32, vertex_index);
			
				if (length < 2) {
				
					buffer_write(object, buffer_u32, 0);
					buffer_write(object, buffer_u32, 0);
				
					return;
				}
			
				var texcoord_index = real_or_undefined(point[ObjFaceComponent.TexCoord]) ?? 0;
			
				buffer_write(object, buffer_u32, texcoord_index);
			
				if (length < 3) {
				
					buffer_write(object, buffer_u32, 0);
					return;
				
				}
			
				var normal_index = real(point[ObjFaceComponent.Normal]);
			
				buffer_write(object, buffer_u32, normal_index);
				
			}
			
		} catch (e) {
			throw $"Failed to parse face command `{cmd}`: {e.longMessage}";
		}
		
	}
	
	/// Write this object to the given vertex buffer.
	/// 
	/// @param {Id.VertexBuffer} vb
		/// @param {String} name The object's name to append to the buffer.
	static write_to_buffer = function(vb, name) {
		
		static testing_light_dir = [0, 0.2, -0.5];
		static default_texcoord = [0, 0];
		static default_normal = [0, 0, 0];
		
		var faces = objects[$ name];
		var face_count_bytes = buffer_tell(faces);
		
		buffer_seek(faces, buffer_seek_start, 0);
		
		while (buffer_tell(faces) < face_count_bytes) {
			
			repeat (3) {
				
				var vertex_index	= int64(buffer_read(faces, buffer_u32) - 1);
				var texcoord_index	= int64(buffer_read(faces, buffer_u32) - 1);
				var normal_index	= int64(buffer_read(faces, buffer_u32) - 1);
				
				var vertex_index_byte	= int64(vertex_index * f32_size * 3);
				var texcoord_index_byte	= int64(texcoord_index * f32_size * 2);
				var normal_index_byte	= int64(normal_index * f32_size * 3);
				
				var vertexX = buffer_peek(self.verts, vertex_index_byte, buffer_f32);
				var vertexY = buffer_peek(self.verts, vertex_index_byte + f32_size, buffer_f32);
				var vertexZ = buffer_peek(self.verts, vertex_index_byte + (f32_size * 2), buffer_f32);
				
				var texcoordX = default_texcoord[X];
				var texcoordY = default_texcoord[Y];
				
				if (texcoord_index != -1) {
					
					texcoordX = buffer_peek(self.texcoords, texcoord_index_byte, buffer_f32);
					texcoordY = buffer_peek(self.texcoords, texcoord_index_byte + f32_size, buffer_f32);
					
				}
				
				var normalX = default_normal[X];
				var normalY = default_normal[Y];
				var normalZ = default_normal[Z];
				
				if (normal_index != -1) {
					
					normalX = buffer_peek(self.normals, normal_index_byte, buffer_f32);
					normalY = buffer_peek(self.normals, normal_index_byte + f32_size, buffer_f32);
					normalZ = buffer_peek(self.normals, normal_index_byte + (f32_size * 2), buffer_f32);
					
				}
				
				var normal_light_dot = dot_product_3d_normalized(
					normalX, normalY, normalZ, 
					testing_light_dir[X], testing_light_dir[Y], testing_light_dir[Z]
				);
				
				vertex_position_3d(vb, vertexX, vertexY, vertexZ);
				vertex_texcoord(vb, texcoordX, texcoordY);
				vertex_normal(vb, normalX, normalY, normalZ);
				vertex_colour(vb, make_color_hsv(0, 10, normal_light_dot * 127 + 127), 1);
				
			}
			
		}
		
	}
	
	static destroy = function() {
		
		buffer_delete(self.verts);
		buffer_delete(self.texcoords);
		buffer_delete(self.normals);
		
		struct_foreach(self.objects, function(key, value) {
			buffer_delete(value);
		});
		
	}
	
	static toString = function() {
		return $"{instanceof(self)}(name={self.name}, verts={self.verts}, faces={self.faces}, texcoords={self.texcoords}, normals={self.normals}, smooth_shading={string_bool(self.smooth_shading)})";
	}
	
}
