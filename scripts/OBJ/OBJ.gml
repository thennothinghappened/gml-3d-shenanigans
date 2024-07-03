
/// Whether or not to perform debug checks to provide proper error messages.
#macro OBJ_DEBUG_CHECKS false

/// Whether to output debug messages.
#macro OBJ_DEBUG_MESSAGES false

/// Prepare an OBJ file's command list to be parsed.
/// 
/// @param {String} text
/// @returns {Array<String>}
function obj_prepare_commands(text) {
	
	var lines = string_split(text, "\n", true);
	return lines;
	
}

/// An OBJ file that contains objects.
function ObjFile() : EventEmitter(["ready"]) constructor {
	
	enum ObjFaceComponent {
		Vertex		= 0,
		TexCoord	= 1,
		Normal		= 2,
	}
	
	enum ObjBuildStatus {
		NoCommandList,
		Building,
		Ready
	}
	
	self.build_status = ObjBuildStatus.NoCommandList;
	self.__build_command_list = undefined;
	self.__build_command_index = 0;
	self.__build_command_count = 0;
	self.__build_current_object = undefined;
	
	self.verts = buffer_create(0, buffer_grow, 1);
	self.texcoords = buffer_create(0, buffer_grow, 1);
	self.normals = buffer_create(0, buffer_grow, 1);
	self.smooth_shading = false;
	
	self.objects = {};
	
	// Populate entry 0 with default values.
	buffer_write(self.texcoords, buffer_f32, 0);
	buffer_write(self.texcoords, buffer_f32, 0);
	
	buffer_write(self.normals, buffer_f32, 0);
	buffer_write(self.normals, buffer_f32, 0);
	buffer_write(self.normals, buffer_f32, 0);
	
	/// Start building from a command list.
	/// @param {Array<String>} commands
	static buildBegin = function(commands) {
		
		if (OBJ_DEBUG_CHECKS) {
			if (self.build_status != ObjBuildStatus.NoCommandList) {
				throw "Cannot start building from a command list when we are in the wrong state!";
			}
		}
		
		self.build_status = ObjBuildStatus.Building;
		self.__build_command_list = commands;
		self.__build_command_index = 0;
		self.__build_command_count = array_length(commands);
		self.__buildBeginObject("default_object");
		
	}
	
	/// Finish building from a command list.
	static buildEnd = function() {
		
		if (OBJ_DEBUG_CHECKS) {
			if (self.build_status != ObjBuildStatus.Building) {
				throw "Cannot finish building from a command list when we were not already building!";
			}
		}
		
		vertex_end(self.__build_current_object);
		
		self.build_status = ObjBuildStatus.Ready;
		self.__build_command_list = undefined;
		self.__build_command_index = 0;
		self.__build_command_count = 0;
		self.__build_current_object = undefined;
		
		self.emit("ready");
		
	}
	
	/// Parse the next OBJ file command.
	/// @returns {Bool} Whether any commands remain.
	static buildParseNext = function() {
		
		if (OBJ_DEBUG_CHECKS) {
			
			if (self.build_status != ObjBuildStatus.Building) {
				throw "Cannot parse commands when not building!";
			}
			
			if (self.__build_command_index >= self.__build_command_count) {
				throw "Tried to parse the next command when none remain!";
			}
			
		}
		
		self.__buildParseCommand(self.__build_command_list[self.__build_command_index++]);
		return (self.__build_command_index < self.__build_command_count);
		
	}
	
	/// Parse a singular OBJ file command while building.
	/// 
	/// @param {String} cmd_string
	static __buildParseCommand = function(cmd_string) {
		
		if (OBJ_DEBUG_CHECKS) {
			if (self.build_status != ObjBuildStatus.Building) {
				throw "Cannot parse commands when not building!";
			}
		}
		
		var cmd = string_split(string_trim(cmd_string), " ");
		
		if (string_length(cmd[0]) == 0 || cmd[0] == "#") {
			return;
		}
		
		var type = array_shift(cmd);
	
		switch (type) {
			
			case "g":
			case "o":
				self.__buildBeginObject(string_join_ext(" ", cmd));
			break;
			
			case "s":
				self.smooth_shading = bool(real(cmd[0]));
			break;
			
			case "v":
				buffer_write(self.verts, buffer_f32, real(cmd[X]));
				buffer_write(self.verts, buffer_f32, real(cmd[Y]));
				buffer_write(self.verts, buffer_f32, real(cmd[Z]));
			break;
			
			case "vt":
				buffer_write(self.texcoords, buffer_f32, real(cmd[X]));
				buffer_write(self.texcoords, buffer_f32, real(cmd[Y]));
			break;
			
			case "vn":
				buffer_write(self.normals, buffer_f32, real(cmd[X]));
				buffer_write(self.normals, buffer_f32, real(cmd[Y]));
				buffer_write(self.normals, buffer_f32, real(cmd[Z]));
			break;
			
			case "f":
				self.__buildFaceFromCommand(cmd);
			break;
			
			case "usemtl":
			case "mtllib":
				if (OBJ_DEBUG_MESSAGES) {
					show_debug_message("TODO: MTL support");
				}
			break;
			
			case "l":
				if (OBJ_DEBUG_MESSAGES) {
					show_debug_message("Lines are not supported in OBJ files!");
				}	
			break;
			
			default:
				throw $"Unknown/Unsupported command type `{type}` in command `{cmd}`";
			break;

		}
		
	}
	
	/// Add an object of the given name, returning its faces buffer.
	/// 
	/// @param {String} name
	/// @returns {Id.VertexBuffer}
	static __buildBeginObject = function(name) {
		
		if (OBJ_DEBUG_CHECKS) {
			if (self.build_status != ObjBuildStatus.Building) {
				throw "Cannot start an object when not building!";
			}
		}
		
		if (self.__build_current_object != undefined) {
			vertex_end(self.__build_current_object);
		}
		
		self.__build_current_object = vertex_create_buffer();
		self.objects[$ name] = self.__build_current_object;
		
		vertex_begin(self.__build_current_object, vformat_main);
	}
	
	/// Read the passed face command and append the face to the buffer.
	/// 
	/// Throws if the command is malformed.
	/// 
	/// @param {Array<String>} cmd
	static __buildFaceFromCommand = function(cmd) {
		
		if (OBJ_DEBUG_CHECKS && array_length(cmd) != 3) {
			throw $"Invalid face command `{cmd}` - must have three components.";
		}
		
		var object = self.__build_current_object;
		
		for (var i = 0; i < 3; i ++) {
			
			var point = string_split(cmd[i], "/", false, 3);
			var length = array_length(point);
			
			var vertex_index = int64(point[ObjFaceComponent.Vertex]) - 1;
			var texcoord_index = 0;
			var normal_index = 0;
			
			if (length > 1) {
				
				texcoord_index = real_or_undefined(point[ObjFaceComponent.TexCoord]) ?? 0;
				
				if (length > 2) {
					normal_index = real(point[ObjFaceComponent.Normal]);
				}
				
			}
			
			var vertex_index_byte	= int64(vertex_index * f32_size * 3);
			var texcoord_index_byte	= int64(texcoord_index * f32_size * 2);
			var normal_index_byte	= int64(normal_index * f32_size * 3);
			
			var vertexX = buffer_peek(self.verts, vertex_index_byte, buffer_f32);
			var vertexY = buffer_peek(self.verts, vertex_index_byte + f32_size, buffer_f32);
			var vertexZ = buffer_peek(self.verts, vertex_index_byte + (f32_size * 2), buffer_f32);
			
			var texcoordX = buffer_peek(self.texcoords, texcoord_index_byte, buffer_f32);
			var texcoordY = buffer_peek(self.texcoords, texcoord_index_byte + f32_size, buffer_f32);
			
			var normalX = buffer_peek(self.normals, normal_index_byte, buffer_f32);
			var normalY = buffer_peek(self.normals, normal_index_byte + f32_size, buffer_f32);
			var normalZ = buffer_peek(self.normals, normal_index_byte + (f32_size * 2), buffer_f32);
			
			vertex_position_3d(object, vertexX, vertexY, vertexZ);
			vertex_texcoord(object, texcoordX, texcoordY);
			vertex_normal(object, normalX, normalY, normalZ);
			vertex_colour(object, c_white, 1);
			
		}
		
	}
	
	/// Write this object to the given vertex buffer.
	/// 
	/// @param {Id.VertexBuffer} vb
	/// @param {String} name The object's name to append to the buffer.
	/// 
	static writeToBuffer = function(vb, name) {
		
		if (OBJ_DEBUG_CHECKS) {
			if (self.build_status != ObjBuildStatus.Ready) {
				throw "Cannot write out to buffer when we're not ready!";
			}
		}
		
		var object = self.objects[$ name];
		
		vertex_update_buffer_from_vertex(
			vb,
			vertex_get_number(vb),
			object,
			0,
			vertex_get_number(object)
		);
		
	}
	
	/// Clean up this OBJ file.
	static destroy = function() {
		
		buffer_delete(self.verts);
		buffer_delete(self.texcoords);
		buffer_delete(self.normals);
		
		struct_foreach(self.objects, function(key, value) {
			vertex_delete_buffer(value);
		});
		
	}
	
	static toString = function() {
		return $"{instanceof(self)}(objects={self.objects}, verts={self.verts}, texcoords={self.texcoords}, normals={self.normals}, smooth_shading={string_bool(self.smooth_shading)})";
	}
	
}
