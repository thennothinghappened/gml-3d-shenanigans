
if (keyboard_check_pressed(ord("L"))) {
	
	var filename = get_open_filename("OBJ File|*.obj", "");
	
	if (filename != "") {
		instance_create_depth(0, 0, 0, oModel, { filename });
	}
	
}
