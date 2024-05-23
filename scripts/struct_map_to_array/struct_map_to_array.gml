
/// Convert a given struct into an array of key-value pairs.
/// 
/// @param {Struct} struct
/// @returns {Array<Array<Any>>}
function struct_map_to_array(struct) {
	
	enum StructPair {
		Key,
		Value
	}
	
	var keys = struct_get_names(struct);
	var num_keys = array_length(keys);
	
	var arr = array_create(num_keys);
	
	for (var i = 0; i < num_keys; i ++) {
		
		var key = keys[i];
		arr[i] = [key, struct[$ key]];
	}
	
	return arr;
	
}
