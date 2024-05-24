/// @desc IO handling system with async loading & caching.

/// Cache of previously loaded OBJ files to re-use.
self.obj_cache = {};

/// Map of IO events by their handles.
self.io_events = ds_map_create();

/// Asynchronously load the given file, running the callback on success or failure.
/// 
/// @param {String} filename
/// @param {Function} callback `(data: Id.Buffer, err?: Struct.Err) -> undefined`
file_load_async = function(filename, callback) {
	
	var buf = buffer_create(0, buffer_grow, 1);
	var handle = buffer_load_async(buf, filename, 0, -1);
	
	self.io_events[? handle] = method({ callback, buf }, function(success) {
		
		if (!success) {
			return callback(buf, new Err("Failed to read the file."));
		}
		
		return callback(buf, undefined);
		
	});
	
}

/// Asynchronously load an OBJ file from the given filename.
/// 
/// @param {String} filename
/// @param {Function} callback `(data: Struct.ObjFile?, err?: Struct.Err) -> undefined`
obj_load_async = function(filename, callback) {
	
	var cached = self.obj_cache[$ filename];
	
	if (is_instanceof(cached, ObjFile)) {
		
		if (cached.build_status == ObjBuildStatus.Ready) {
			return callback(cached, undefined);
		}
		
		return cached.on("ready", method({ callback, cached }, function() {
			callback(cached, undefined);
		}));
		
	}
	
	file_load_async(filename, method({ callback, filename }, function(data, err) {
		
		if (is_instanceof(err, Err)) {
		
			buffer_delete(data);
			return callback(undefined, new Err($"Failed to load the OBJ file `{filename}`", err));
		
		}
	
		var text = buffer_read(data, buffer_text);
		buffer_delete(data);
		
		var commands = obj_prepare_commands(text);
		var file = new ObjFile();
		
		oIoSystem.obj_cache[$ filename] = file;
		
		oWorkManager.job_enqueue(method({ file }, function() {
			
			if (file.build_parse_next_command() == false) {
				
				file.build_finish();
				return true;
				
			}
			
			return false;
			
		}));
		
		file.build_start(commands);
		
		oIoSystem.obj_load_async(filename, callback);
		
	}));
	
}
