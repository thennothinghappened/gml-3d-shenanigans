
/// Model IO manager to asynchronously read and parse model data, currently just OBJ files.
/// 
/// @param {Id.Instance<oIoSystem>} _io
/// @param {Id.Instance<oWorkManager>} _workManager
function ModelManager(_io, _workManager) constructor {
	TYPEHINT { io = instance_find(oIoSystem, 0) }
	io = _io;
	
	TYPEHINT { workManager = instance_find(oWorkManager, 0) }
	workManager = _workManager;
	
	/// Previously loaded and currently loading OBJ files, by filename.
	/// @type {Struct<string, Struct.ObjFile>}
	objCache = {};
	
	/// Asynchronously load an OBJ file from the given filename.
	/// 
	/// If the object with that path has already been loaded, it'll be immediately resolved.
	/// 
	/// @param {String} filename
	/// @param {Function} callback `(data: Struct.ObjFile?, err: Struct.Err?) -> Undefined`
	static objLoadAsync = function(filename, callback) {
		/// @type {Struct.ObjFile|Undefined}
		var cached = objCache[$ filename];
		
		if (is_instanceof(cached, ObjFile)) {
			if (cached.build_status == ObjBuildStatus.Ready) {
				return callback(cached, undefined);
			}
			
			return cached.on("ready", method({ callback, cached }, function() {
				callback(cached, undefined);
			}));
		}
		
		var modelManager = self;
		var workManager = self.workManager;
		
		io.fileLoadAsync(filename, method({ modelManager, workManager, callback, filename }, function(data, err) {
			if (is_instanceof(err, Err)) {
				return callback(undefined, new Err($"Failed to load the OBJ file `{filename}`", err));
			}
			
			var text = buffer_read(data, buffer_text);
			buffer_delete(data);
			
			var file = new ObjFile(text);
			
			modelManager.objCache[$ filename] = file;
			modelManager.objLoadAsync(filename, callback);
			
			workManager.job_enqueue(method(file, file.buildParseNext));
		}));
	}
}
