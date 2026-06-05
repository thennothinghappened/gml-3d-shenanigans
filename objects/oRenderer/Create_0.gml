/// @desc A game renderer instance, which renders using an active camera instance.

if (!variable_instance_exists(self, "environment")) {
	environment = new Environment(
		[0, 0.2, 0.5],
		[52, 137, 235, 255]
	);
}

/// The active camera to render with, if any.
activeCamera = undefined;
