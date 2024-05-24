/// @desc Handle an IO Event.

var handle = async_load[? "id"];
var success = async_load[? "status"];

if (!ds_map_exists(self.io_events, handle)) {
	exit;
}

var callback = self.io_events[? handle];
ds_map_delete(self.io_events, handle);

callback(success);
