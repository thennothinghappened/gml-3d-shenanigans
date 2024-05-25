/// @desc Setup the game work manager. There must be only one work manager at a time.

if (instance_number(oWorkManager) != 1) {
	throw new Err("FATAL: There cannot be more than one work manager active at a time.");
}

/// Minimum number of work entries to process per frame, even if our framerate is suffering.
self.queue_min_count = 10;

/// Time in microseconds the frame started at for determining what work we can do.
self.__frame_start = 0;

/// Number of frames to smooth the work accumulation average over.
self.__work_done_accumulator_frames = 10;

/// Accumulator for the amount of work being done on average.
self.__work_done_accumulator = array_create(self.__work_done_accumulator_frames, 0);

/// Queue of backround work callbacks.
self.work_queue = ds_queue_create();

/// Add a job to the work queue. The job is a callback which returns true when it is done.
/// 
/// > ```gml
/// > oWorkManager.job_enqueue(function() {
/// >	
/// > 	static iteration = 0;
/// > 
/// > 	show_debug_message(iteration);
/// > 
/// > 	if (iteration > 20) {
/// > 		return true;
/// > 	}
/// >	
/// > 	iteration ++;
/// > 	return false;
/// >	
/// > });
/// > ```
/// 
/// @param {Function} job `() -> Bool` The Job to enqueue.
/// 
job_enqueue = function(job) {
	ds_queue_enqueue(self.work_queue, job);
}

/// Get the average amount of work performed per frame.
/// @returns {Real}
work_get_frame_average = function() {
	return array_reduce(self.__work_done_accumulator, function(prev, current) {
		return prev + current;
	}) / self.__work_done_accumulator_frames;
}
