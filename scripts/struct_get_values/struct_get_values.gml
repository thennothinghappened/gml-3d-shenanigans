
/// Get the values of a struct as an array.
/// @param {Struct} struct
function struct_get_values(struct) {
	
	var pairs = struct_map_to_array(struct);
	
	var values = array_map(pairs, function(pair) {
		return pair[StructPair.Value];
	});
	
	return values;
}
