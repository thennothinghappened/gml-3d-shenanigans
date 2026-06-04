
/// Create an instance in 3D space at the given coordinates.
/// 
/// @param {Real} x
/// @param {Real} y
/// @param {Real} z
/// @param {Asset.GMObject} obj
/// @param {Struct} [var_struct]
function instance_create_3d(x, y, z, obj, var_struct = {}) {
	var_struct.z = z;
	return instance_create_depth(x, y, 0, obj, var_struct);
}
