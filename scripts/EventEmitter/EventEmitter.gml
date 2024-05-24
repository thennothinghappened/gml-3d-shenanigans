
/// Abstract class for something that emits listenable events.
/// @param {Array<String>} event_names List of event names to register
function EventEmitter(event_names) constructor {
	
	self.events = {};
	
	/// Subscribe to an event as a listener.
	/// 
	/// @param {String} event Event to listen to.
	/// @param {Function} listener Callback to listen with.
	static on = function(event, listener) {
		
		self.__ensure_event(event);
		array_push(self.events[$ event], listener);
		
	}
	
	/// Remove a listen to an event.
	/// 
	/// @param {String} event Event listening to.
	/// @param {Function} listener Callback to remove from the list.
	static off = function(event, listener) {
		
		self.__ensure_event(event);
		
		var listeners = self.events[$ event];
		
		var idx = array_find_index(listeners, method({ desired_listener: listener }, function(listener) {
			return listener == desired_listener;
		}));
		
		if (idx == -1) {
			throw $"No listener `{listener}` registered for event `{event}`";
		}
		
		array_delete(listeners, idx, 1);
		
	}
	
	/// [Protected] Emit a given event name to all listeners.
	/// 
	/// @param {String} event Event name to emit.
	/// @param {Struct|undefined} [params] Parameters to send
	static emit = function(event, params) {
		
		self.__ensure_event(event);
		
		array_foreach(self.events[$ event], method({ params }, function(listener) {
			listener(params);
		}));
		
	}
	
	/// [Protected] Add an event name to the list of events.
	/// 
	/// @param {String} event Event name to add.
	static register = function(event) {
		self.events[$ event] = [];
	}
	
	/// Ensure the given event name exists.
	/// @param {String} event
	static __ensure_event = function(event) {
		if (!struct_exists(events, event)) {
			throw new Err($"No such event named `{event}` - possible values are [{string_join_ext(", ", struct_get_names(self.events))}]");
		}
	}
	
	// Register the passed in events immediately
	array_foreach(event_names, register);
	
}
