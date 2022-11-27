
// Write directly JavaScript console.  This can be useful for debugging since it
// bypasses the stdio and filesystem sub-systems.
pub const log = emscripten_console_log;
pub const warn = emscripten_console_warn;
pub const err = emscripten_console_error;   
extern fn emscripten_console_log(utf8_string : [*:0] const u8) void;
extern fn emscripten_console_warn(utf8_string : [*:0] const u8) void;
extern fn emscripten_console_error(utf8_string : [*:0] const u8) void;

// Write to the out() and err() hooks directly (defined in shell.js).
// These have different behavior compared to console.log/err.
// Under node, they write to stdout and stderr which is a more direct way to
// write output especially in worker threads.
// The default behavior of these functions can be overridden by print and
// printErr, if provided on the Module object.
// These functions are mainly intended for internal use.
// See https://github.com/emscripten-core/emscripten/issues/14804 
pub extern fn _emscripten_out(utf8_string : [*:0] const u8) void;
pub extern fn _emscripten_err(utf8_string : [*:0] const u8) void;

// Similar to the above functions but operate with printf-like semantics.
pub fn logF(fmt: [*:0]const u8, args: anytype) void {
    return @call(.{}, emscripten_console_logf, .{fmt} ++ args);
}

pub fn warnF(fmt: [*:0]const u8, args: anytype) void {
    return @call(.{}, emscripten_console_warnf, .{fmt} ++ args);
}

pub fn errF(fmt: [*:0]const u8, args: anytype) void {
    return @call(.{}, emscripten_console_errorf, .{fmt} ++ args);
}
pub extern fn emscripten_console_logf(utf8_string : [*:0] const u8, ...) void; // __attribute__((__format__(printf, 1, 2)))
pub extern fn emscripten_console_warnf(utf8_string : [*:0] const u8, ...)  void; // __attribute__((__format__(printf, 1, 2)))
pub extern fn emscripten_console_errorf(utf8_string : [*:0] const u8, ...) void; // __attribute__((__format__(printf, 1, 2))) 
pub extern fn _emscripten_outf(utf8_string : [*:0] const u8, ...)  void; // __attribute__((__format__(printf, 1, 2)))
pub extern fn _emscripten_errf(utf8_string : [*:0] const u8, ...)  void; // __attribute__((__format__(printf, 1, 2)))
