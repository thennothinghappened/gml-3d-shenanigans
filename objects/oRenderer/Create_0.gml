/// @desc A game renderer instance. The renderer owns a camera.

if (!variable_instance_exists(self, "camera")) {
	self.camera = instance_create_depth(0, 0, 0, oCamera);
}

if (!variable_instance_exists(self, "environment")) {
	self.environment = new Environment(
		[0, 0.2, 0.5],
		[90, 100, 150, 255]
	);
}

/// Queue of {@link Asset.GMObject.oModel} instances that can be rendered.
self.renderable_models = ds_queue_create();

/// Queue of {@link Asset.GMObject.oModel} instances that are currently loading in.
self.loading_models = ds_queue_create();
