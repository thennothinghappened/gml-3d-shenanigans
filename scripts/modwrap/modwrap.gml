
/// `mod` or `%` but works as expected for negative numbers.
/// 
/// @pure
/// @param {Real} a
/// @param {Real} b
/// @returns {Real}
/// 
function modwrap(a, b) {
	return a - b * floor(a / b);
}
