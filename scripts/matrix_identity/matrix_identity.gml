
/// Get the identity matrix.
/// 
/// @returns {Array<Real>}
/// 
function __matrix_identity_get() {
	
	static __matrix = matrix_build_identity();
	return __matrix;
	
}

#macro matrix_identity __matrix_identity_get()
