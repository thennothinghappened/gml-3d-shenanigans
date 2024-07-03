
/// Controller wrapper for the application window
/// @param {Real} fps_foreground Framerate to run at while the application is focused.
/// @param {Real} fps_background Framerate to run at while the application is in the background.
function AppWindow(
	fps_foreground = 60,
	fps_background = 5
) : EventEmitter(["resize", "focuschange"]) constructor {
	
	self.fps_background = fps_background;
	self.fps_foreground = fps_foreground;
	
	self.focused = window_has_focus();
	
	self.width = window_get_width();
	self.height = window_get_height();
	
	self.aspect_ratio = self.width / self.height;
	
	static __window_get_width = function() {
		
		if (os_browser != browser_not_a_browser) {
			return browser_width;
		}
		
		if (os_type == os_android) {
			return display_get_width();
		}
		
		return window_get_width();
		
	}
		
	static __window_get_height = function() {
		
		if (os_browser != browser_not_a_browser) {
			return browser_height;
		}
		
		if (os_type == os_android) {
			return display_get_height();
		}
		
		return window_get_height();
		
	}
	
	/// Setup the application window!
	static init = function() {
		
		// Set framerate on focus changed
		on("focuschange", function(params) {
			game_set_speed(params.focused ? self.fps_foreground : self.fps_background, gamespeed_fps);
		});
		
		// Resize app surface & GUI.
		on("resize", __on_resize);
		
		// On Android we want to be the full screen size at startup.
		if (os_type == os_android) {
			resize(__window_get_width(), __window_get_height());
		}
		
	}
	
	/// Update any window changes.
	static update = function() {
		
		var old_focused = self.focused;
		self.focused = window_has_focus();
		
		if (self.focused != old_focused) {
			emit("focuschange", { focused });
		}
		
		var old_width = self.width;
		var old_height = self.height;
		
		self.width = __window_get_width();
		self.height = __window_get_height();
		
		if (self.width != old_width || self.height != old_height) {
			emit("resize", { width, height });
		}
		
	}
	
	/// Callback for when the window is resized.
	static __on_resize = function(params) {
		
		self.aspect_ratio = params.width / params.height;
		
		// The browser requires we also resize the window itself
		if (os_browser != browser_not_a_browser) {
			
			window_set_size(params.width, params.height);
			logger.debug("AppWindow", "TODO: implement proper resizing on HTML5");
			
			return;
		}
		
		surface_resize(application_surface, max(params.width, 1), max(params.height, 1));
	}
	
	/// Resize the application window to a given width and height.
	/// @param {Real} width
	/// @param {Real} height
	static resize = function(width, height) {
		
		self.width = _width;
		self.height = _height;
		
		window_set_size(width, height);
		
		emit("resize", { width, height });
	}
	
}
