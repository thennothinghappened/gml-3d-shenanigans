
#macro logger __logger_get()

/// Get the active Logger singleton.
/// @returns {Struct.Logger}
function __logger_get() {
	static __logger = new Logger(true, LogSeverity.Debug);
	return __logger;
}

enum LogSeverity {
	Debug,
	Info,
	Warn,
	Error,
	Fatal
}

enum __LogEntryIndex {
	Time = 0,
	Severity = 1,
	Source = 2,
	Message = 3
}

/// Instance of a logger, that keeps track of game logs for us!
/// 
/// @param {Bool} print_to_console Whether to print game logs to the output console.
/// @param {Enum.LogSeverity} min_print_severity Minimum severity to bother printing to the console.
/// @param {Real} log_buffer_size How large the circular log buffer is in bytes (chars). Default size is 1024^2 bytes = 1mb
/// 
function Logger(
	print_to_console = true,
	min_print_severity = LogSeverity.Info,
	log_buffer_size = buffer_sizeof(buffer_u8) * 1024 * 1024
) constructor {
	
	/// @ignore
	/// @type {Enum.LogSeverity}
	self.min_print_severity = min_print_severity;
	
	/// @ignore
	/// @type {Id.Buffer}
	self.__log_entries = buffer_create(log_buffer_size, buffer_wrap, 1);
	
	/// @ignore
	/// 
	/// Create a logger entry
	/// 
	/// @param {String} text Text to write to the log.
	/// 
	static __entry_create = function(text) {
		buffer_write(self.__log_entries, buffer_text, text + "\n");
	}
	
	/// @ignore
	/// 
	/// Return a readable stringified version of a log entry.
	/// 
	/// @pure
	/// @param {Enum.LogSeverity} severity
	/// @param {String} source
	/// @param {Any} message
	/// 
	static __entry_tostring = function(severity, source, message) {
		
		static severity_readable = [
			"Debug",
			"Info",
			"Warn",
			"Error",
			"FATAL"
		];
		
		return $"[{current_time / 1000}] [{severity_readable[severity]}] [{source}] {message}";
	}
	
	/// @ignore
	/// 
	/// Write something to the log!
	/// 
	/// @param {Enum.LogSeverity} severity
	/// @param {String} source
	/// @param {Any} message
	/// 
	static __log = function(severity, source, message) {
		__entry_create(__entry_tostring(severity, source, message));
	}
	
	/// @ignore
	/// 
	/// Write something to the log and print it to the console.
	/// 
	/// @param {Enum.LogSeverity} severity
	/// @param {String} source
	/// @param {Any} message
	/// 
	static __log_and_print = function(severity, source, message) {
		
		var text = __entry_tostring(severity, source, message);
		__entry_create(text);
		
		if (severity >= min_print_severity) {
			show_debug_message(text);
		}
	}
	
	/// Write something to this log!
	/// 
	/// @param {Enum.LogSeverity} severity
	/// @param {String} source
	/// @param {Any} message
	/// 
	log = (print_to_console)
		? __log_and_print
		: __log;
	
	/// Write a debug message to the log.
	/// 
	/// @param {String} source
	/// @param {Any} message
	/// 
	static debug = function(source, message) {
		log(LogSeverity.Debug, source, message);
	}
	
	/// Write a info message to the log.
	/// 
	/// @param {String} source
	/// @param {Any} message
	/// 
	static info = function(source, message) {
		log(LogSeverity.Info, source, message);
	}
	
	/// Write a warning to the log.
	/// 
	/// @param {String} source
	/// @param {Any} message
	/// 
	static warn = function(source, message) {
		log(LogSeverity.Warn, source, message);
	}
	
	/// Write an error message to the log.
	/// 
	/// @param {String} source
	/// @param {Any} message
	/// 
	static error = function(source, message) {
		log(LogSeverity.Error, source, message);
	}
	
	/// Write a fatal error to the log.
	/// 
	/// @param {String} source
	/// @param {Any} message
	/// 
	static fatal = function(source, message) {
		log(LogSeverity.Fatal, source, message);
	}
}
