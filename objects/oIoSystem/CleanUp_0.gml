/// @desc Clean up the IO map.

ds_map_destroy(self.io_events);
ds_queue_destroy(self.obj_build_queue);
