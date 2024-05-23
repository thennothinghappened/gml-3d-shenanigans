
/// A 2-dimensional vector.
/// @param {Real} x
/// @param {Real} [y]
function Vec2(x, y) constructor {

	self.x = x;
	self.y = y ?? x;
	
	/// Add this vector and another Vec2 or number, returning a new Vec2.
	/// 
	/// @param {Real|Struct.Vec2} v
	/// @returns {Struct.Vec2}
	static add = function(v) {

		if (is_instanceof(v, Vec2)) {
			return new Vec2(self.x + v.x, self.y + v.y);
		}
		
		return new Vec2(self.x + v, self.y + v);
	}
	
	/// Subtract another Vec2 or number from this vector, returning a new Vec2.
	/// 
	/// @param {Real|Struct.Vec2} v
	/// @returns {Struct.Vec2}
	static sub = function(v) {

		if (is_instanceof(v, Vec2)) {
			return new Vec2(self.x - v.x, self.y - v.y);
		}
		
		return new Vec2(self.x - v, self.y - v);
	}
	
	/// Multiply this vector with another Vec2 or number, returning a new Vec2.
	/// 
	/// @param {Real|Struct.Vec2} v
	/// @returns {Struct.Vec2}
	static mul = function(v) {

		if (is_instanceof(v, Vec2)) {
			return new Vec2(self.x * v.x, self.y * v.y);
		}
		
		return new Vec2(self.x * v, self.y * v);
	}
	
	/// Divide another Vec2 or number by this vector, returning a new Vec2.
	/// 
	/// @param {Real|Struct.Vec2} v
	/// @returns {Struct.Vec2}
	static div_by = function(v) {

		if (is_instanceof(v, Vec2)) {
			return new Vec2(self.x / v.x, self.y / v.y);
		}
		
		return new Vec2(self.x / v, self.y / v);
	}
	
}
