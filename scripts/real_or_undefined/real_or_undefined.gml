
/// Convert the given value to a real, or undefined on failure.
/// 
/// @pure
/// @param {Any} value
/// @returns {Real|Undefined}
/// 
function real_or_undefined(value) {
	
	if (value == "") {
		return undefined;
	}
	
	try {
		return real(value);
	} catch (_) {
		return undefined;
	}
	
}
