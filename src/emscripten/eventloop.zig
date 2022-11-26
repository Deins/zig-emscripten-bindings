const EmBool = @import("em_types.zig").EmBool;

// zig
pub const unwindToJsEventLoop = emscripten_unwind_to_js_event_loop;

pub const setTimeout = emscripten_set_timeout;
pub const clearTimeout = emscripten_clear_timeout;
pub const setTimeout_loop = emscripten_set_timeout_loop;
pub const setTimeout_loop = emscripten_set_timeout_loop;

pub const setImmediate = emscripten_set_immediate;
pub const clearImmediate = emscripten_clear_immediate;
pub const setImmediate_loop = emscripten_set_immediate_loop;

pub const setInterval = emscripten_set_interval;
pub const clearInterval = emscripten_clear_interval;

pub const runtimeKeepalivePush = emscripten_runtime_keepalive_push;
pub const runtimeKeepalivePop = emscripten_runtime_keepalive_pop;
pub const runtimeKeepaliveCheck = emscripten_runtime_keepalive_check;

// extern
pub extern fn emscripten_unwind_to_js_event_loop(void) noreturn;

pub extern fn emscripten_set_timeout(cb: *const fn (user_data: ?*anyopaque) void, msecs: f64, user_data: ?*anyopaque) u64;
pub extern fn emscripten_clear_timeout(setTimeoutId: u64) void;
pub extern fn emscripten_set_timeout_loop(u64) void;
pub extern fn emscripten_set_timeout_loop(*const fn (time: f64, user_data: ?*anyopaque) em_types.EmBool, interval_msecs: f64, user_data: ?*anyopaque) void;

pub extern fn emscripten_set_immediate(cb: *const fn (user_data: ?*anyopaque) void, user_data: ?*anyopaque) u64;
pub extern fn emscripten_clear_immediate(set_immediate_id: u64) void;
pub extern fn emscripten_set_immediate_loop(cb: *const fn (user_data: ?*anyopaque) EmBool, user_data: ?*anyopaque) void;

pub extern fn emscripten_set_interval(cb: *const fn (user_data: *anyopaque) void, interval_msecs: f64, user_data: *anyopaque) u64;
pub extern fn emscripten_clear_interval(set_interval_id: u64) void;

pub extern fn emscripten_runtime_keepalive_push() void;
pub extern fn emscripten_runtime_keepalive_pop() void;
pub extern fn emscripten_runtime_keepalive_check() EmBool;
