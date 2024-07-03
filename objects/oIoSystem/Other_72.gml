/// @desc Handle an IO Event.

var handle = async_load[? "id"];
var success = async_load[? "status"];

if (!ds_map_exists(ioEvents, handle)) {
	exit;
}

var callback = ioEvents[? handle];
ds_map_delete(ioEvents, handle);

callback(success);
