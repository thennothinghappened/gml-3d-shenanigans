/// @desc Main game setup.

#macro game oGame

window = new AppWindow(170, 5);
workManager = instance_create_depth(0, 0, 0, oWorkManager);
ioSystem = instance_create_depth(0, 0, 0, oIoSystem);
renderer = instance_create_depth(0, 0, 0, oRenderer);

window.init();

player = instance_create_depth(0, 0, 0, oPlayer);
renderer.activeCamera = player.camera;
