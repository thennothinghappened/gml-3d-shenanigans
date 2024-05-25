/// @desc Process the work queue.

var max_frame_length = game_get_speed(gamespeed_microseconds);
var work_done = 0;

while (true) {
	
	if (ds_queue_size(self.work_queue) == 0) {
		break;
	}
	
	if (work_done > self.queue_min_count) {
		
		var current_frame_length = get_timer() - self.__frame_start;
		
		if (current_frame_length > max_frame_length) {
			break;
		}
		
	}
	
	var job = ds_queue_dequeue(self.work_queue);
	var done = job();
	
	if (!done) {
		ds_queue_enqueue(self.work_queue, job);
	}
	
	work_done ++;
	
}

array_shift(self.__work_done_accumulator);
array_push(self.__work_done_accumulator, work_done);
