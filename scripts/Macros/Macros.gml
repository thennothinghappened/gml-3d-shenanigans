
/// Array indicies for arrays in the form [x, y, z], which are slightly faster than a struct.
#macro X 0
#macro Y 1
#macro Z 2

/// Hint to Feather what the type of a variable is through pretending to do something with it.
/// 
/// Unfortuantely, Feather doesn't support @type annotations yet.
#macro TYPEHINT if (false)
