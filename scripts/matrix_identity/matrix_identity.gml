
/// Get the identity matrix.
function __matrix_identity_get() {
	
	static __matrix = matrix_build_identity();
	return __matrix;
	
}

#macro matrix_identity __matrix_identity_get()
