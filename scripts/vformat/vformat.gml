
/// Get the project's main vertex format.
function __vformat_main_get() {
	
	static __ready = false;
	static __vfmt = undefined;
	
	if (!__ready) {
		
		vertex_format_begin();
		
		vertex_format_add_position_3d();
		vertex_format_add_texcoord();
		vertex_format_add_normal();
		vertex_format_add_colour();
		
		__vfmt = vertex_format_end();
		__ready = true;
		
	}
	
	return __vfmt;
	
}

#macro vformat_main __vformat_main_get()
