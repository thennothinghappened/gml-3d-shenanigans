/// @desc Process the build queue.

var max_frame_length = game_get_speed(gamespeed_microseconds);

if (ds_queue_size(self.obj_build_queue) > 0) {
	
	var file = ds_queue_dequeue(self.obj_build_queue);
	var done = false;
	
	var commands_run = 0;
	
	while (true) {
		
		if (commands_run > self.obj_build_queue_min_command_count) {
			
			var current_frame_length = get_timer() - self.__frame_start;
			
			if (current_frame_length > max_frame_length) {
				break;
			}
			
		}
		
		if (file.build_parse_next_command() == false) {
			done = true;
			break;
		}
		
		commands_run ++;
		
	}
	
	if (done) {
		file.build_finish();
	} else {
		ds_queue_enqueue(self.obj_build_queue, file);
	}
	
}
