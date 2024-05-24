/// @desc Setup the game work manager. There must be only one work manager at a time.

if (instance_number(oWorkManager) != 1) {
	throw new Err("FATAL: There cannot be more than one work manager active at a time.");
}

/// Minimum number of work entries to process per frame, even if our framerate is suffering.
self.queue_min_count = 10;

/// Time in microseconds the frame started at for determining what work we can do.
self.__frame_start = 0;

/// Queue of backround work callbacks.
self.work_queue = ds_queue_create();

/// Add a job to the work queue. The job is a callback which returns true when it is done.
/// @param {Function} job `() -> Bool`
job_enqueue = function(job) {
	ds_queue_enqueue(self.work_queue, job);
}
