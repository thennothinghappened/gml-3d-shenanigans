/// @desc Process the build queue.

if (ds_queue_size(self.obj_build_queue) > 0) {
	
	var file = ds_queue_dequeue(self.obj_build_queue);
	var done = false;
	
	repeat (self.obj_build_queue_command_count) {
		
		if (file.build_parse_next_command() == false) {
			done = true;
			break;
		}
		
	}
	
	if (done) {
		file.build_finish();
	} else {
		ds_queue_enqueue(self.obj_build_queue, file);
	}
	
}
