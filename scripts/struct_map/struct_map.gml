
/// Map the given struct to another struct using the supplied function.
/// @param {Struct} struct
/// @param {Function} func
function struct_map(struct, func) {
	
	var keys = struct_get_names(struct);
	var out_struct = {};
	
	for (var i = 0, num_keys = array_length(keys); i < num_keys; i ++) {
		
		var key = keys[i];
		out_struct[$ key] = func(key, struct[$ key]);
		
	}
	
	return out_struct;

}
