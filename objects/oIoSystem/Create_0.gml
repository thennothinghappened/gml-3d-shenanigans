/// @desc IO handling system with async loading.

/// Map of IO events by their handles.
ioEvents = ds_map_create();

/// Asynchronously load the given file, running the callback on success or failure.
/// 
/// The callback passed has the responsibility of cleaning up the data buffer on success.
/// 
/// ```gml
/// oIoSystem.fileLoadAsync("test.txt", function(data, err) {
/// 	if (is_instanceof(err, Err)) {
/// 		show_error(err.toString(), true);
/// 	}
/// 
/// 	var text = buffer_read(data, buffer_text);
/// 	buffer_delete(data);
/// 	
/// 	show_message(text);
/// });
/// ```
/// 
/// @param {String} filename Name of the file to be loaded.
/// @param {Function} callback `(data?: Id.Buffer, err?: Struct.Err) -> undefined`
/// 
fileLoadAsync = function(filename, callback) {
	var buf = buffer_create(0, buffer_grow, 1);
	var handle = buffer_load_async(buf, filename, 0, -1);
	
	ioEvents[? handle] = method({ callback, buf }, function(success) {
		if (!success) {
			buffer_delete(buf);
			return callback(undefined, new Err("Failed to read the file."));
		}
		
		return callback(buf, undefined);
	});
}
