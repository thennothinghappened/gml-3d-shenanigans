
/// A 3-dimensional vector.
/// @param {Real} x
/// @param {Real} [y]
/// @param {Real} [z]
function Vec3(x, y, z) : Vec2(x, y) constructor {

	self.z = z ?? x;
	
	/// Add this vector and another vector or number, returning a new vector.
	/// 
	/// @param {Real|Struct.Vec3} v
	/// @returns {Struct.Vec3}
	static add = function(v) {

		if (is_instanceof(v, Vec3)) {
			return new Vec3(self.x + v.x, self.y + v.y, self.z + v.z);
		}
		
		return new Vec3(self.x + v, self.y + v, self.z + v);
	}
	
	/// Subtract another vector or number from this vector, returning a new vector.
	/// 
	/// @param {Real|Struct.Vec3} v
	/// @returns {Struct.Vec3}
	static sub = function(v) {

		if (is_instanceof(v, Vec3)) {
			return new Vec3(self.x - v.x, self.y - v.y, self.z - v.z);
		}
		
		return new Vec3(self.x - v, self.y - v, self.z - v);
	}
	
	/// Multiply this vector with another vector or number, returning a new vector.
	/// 
	/// @param {Real|Struct.Vec3} v
	/// @returns {Struct.Vec3}
	static mul = function(v) {

		if (is_instanceof(v, Vec3)) {
			return new Vec3(self.x * v.x, self.y * v.y, self.z * v.z);
		}
		
		return new Vec3(self.x * v, self.y * v, self.z * v);
	}
	
	/// Divide another vector or number by this vector, returning a new vector.
	/// 
	/// @param {Real|Struct.Vec3} v
	/// @returns {Struct.Vec3}
	static div_by = function(v) {

		if (is_instanceof(v, Vec3)) {
			return new Vec3(self.x / v.x, self.y / v.y, self.z / v.z);
		}
		
		return new Vec3(self.x / v, self.y / v, self.z / v);
	}
	
	/// Get the dot product of this vector and another vector.
	///
	/// @param {Struct.Vec3} v
	/// @returns {Real}
	static dot = function(v) {
		return dot_product_3d(self.x, self.y, self.z, v.x, v.y, v.z);
	}
	
	/// Get the *normalized* dot product of this vector and another vector.
	///
	/// @param {Struct.Vec3} v
	/// @returns {Real}
	static dot_normalized = function(v) {
		return dot_product_3d_normalized(self.x, self.y, self.z, v.x, v.y, v.z);
	}
	
}
