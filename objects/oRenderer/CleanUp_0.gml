/// @desc Deallocate render queues and camera.

ds_queue_destroy(self.renderable_models);
ds_queue_destroy(self.loading_models);
instance_destroy(self.camera);
