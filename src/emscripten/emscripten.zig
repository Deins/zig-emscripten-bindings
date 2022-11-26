// NOTE: here are only exports
// #include "em_asm.h"
// #include "em_macros.h"
// #include "em_types.h"
// #include "em_js.h"
// #include "wget.h"
// #include "version.h"
const em_types = @import("em_types.zig");
const CallbackFunc = em_types.EmCallbackFunc;
const ArgCallbackFunc = em_types.EmArgCallbackFunc;

pub const runScript = emscripten_run_script;
pub const runScriptInt = emscripten_run_script_int;
pub const runScriptString = emscripten_run_script_string;
pub const asyncRunScript = emscripten_async_run_script;
pub const loadScript = emscripten_async_load_script;
pub const setMainLoop = emscripten_set_main_loop;

pub const setMainLoopTiming = emscripten_set_main_loop_timing;
pub const getMainLoopTiming = emscripten_get_main_loop_timing;
pub const setMainLoopArg = emscripten_set_main_loop_arg;
pub const pauseMainLoop = emscripten_pause_main_loop;
pub const resumeMainLoop = emscripten_resume_main_loop;
pub const cancelMainLoop = emscripten_cancel_main_loop;

const SocketCallback = *const fn (fd: i32, user_data: ?*anyopaque) void;
const SocketErrorCallback = *const fn (fd: i32, err: i32, msg: [*:0]const u8, user_data: ?*anyopaque) void;
pub const setSocketErrorCallback = emscripten_set_socket_error_callback;
pub const setSocketOpenCallback = emscripten_set_socket_open_callback;
pub const setSocketListenCallback = emscripten_set_socket_listen_callback;
pub const setSocketConnectionCallback = emscripten_set_socket_connection_callback;
pub const setSocketMessageCallback = emscripten_set_socket_message_callback;
pub const setSocketCloseCallback = emscripten_set_socket_close_callback;

//TODO: emscripten_push

pub const setMainLoopExpectedBlockers = emscripten_set_main_loop_expected_blockers;

pub const asyncCall = emscripten_async_call;

pub const exitWithLiveRuntime = emscripten_exit_with_live_runtime;
pub const forceExit = emscripten_force_exit;

pub const getDevicePixelRatio = emscripten_get_device_pixel_ratio;

pub const getWindowTitle = emscripten_get_window_title;
pub const setWindowTitle = emscripten_set_window_title;
pub const getScreenSize = emscripten_get_screen_size;
pub const hideMouse = emscripten_hide_mouse;
// deprecated:
//extern fn emscripten_set_canvas_size(int width, int height) __attribute__((deprecated("This variant does not allow specifying the target canvas", "Use emscripten_set_canvas_element_size() instead"))) void;
//extern fn emscripten_get_canvas_size(int *width, int *height, int *isFullscreen) __attribute__((deprecated("This variant does not allow specifying the target canvas", "Use emscripten_get_canvas_element_size() and void emscripten_get_fullscreen_status() instead")));

pub const getNow = emscripten_get_now;
pub const random = emscripten_random;

// TODO: IDB

pub const getCompilerSetting = emscripten_get_compiler_setting;
pub const hasAsyncify = emscripten_has_asyncify;

pub const debugger = emscripten_debugger();

pub const getPreloadedImageData = emscripten_get_preloaded_image_data;
pub const getPreloadedImageDataFrom_FILE = emscripten_get_preloaded_image_data_from_FILE;

pub const log = emscripten_log;

pub const getCallsStack = emscripten_get_callstack;

pub const printDouble = emscripten_print_double;

// TODO:
// typedef void (*em_scan_func)(void*, void*);
// void emscripten_scan_registers(em_scan_func func);
// void emscripten_scan_stack(em_scan_func func);

// Asynchronous version of dlopen.  Since WebAssembly module loading in general
// is asynchronous the normal dlopen function can't be used in all situations.
// typedef void (*em_dlopen_callback)(void* handle, void* user_data);
// void emscripten_dlopen(const char *filename, int flags, void* user_data, em_dlopen_callback onsuccess, em_arg_callback_func onerror);

pub const throwNumber = emscripten_throw_number;
pub const throwString = emscripten_throw_string;

pub const sleep = emscripten_sleep;

//
// Extern
//
extern fn emscripten_run_script(script: [*:0]const u8) void;
extern fn emscripten_run_script_int(script: [*:0]const u8) i32;
extern fn emscripten_run_script_string(script: [*:0]const u8) [*:0]const u8;
extern fn emscripten_async_run_script(script: [*:0]const u8, millis: i32) void;
extern fn emscripten_async_load_script(script: [*:0]const u8, onload: CallbackFunc, onerror: CallbackFunc) void;

extern fn emscripten_set_main_loop(func: CallbackFunc, fps: i32, simulate_infinite_loop: i32) void;

pub const EmTiming = enum(u32) {
    settimeout = 0, // EM_TIMING_SETTIMEOUT
    timing_raf = 1, // EM_TIMING_RAF
    setimmediate = 2, // EM_TIMING_SETIMMEDIATE
};

extern fn emscripten_set_main_loop_timing(mode: i32, value: i32) c_int;
extern fn emscripten_get_main_loop_timing(mode: *i32, value: *i32) void;
extern fn emscripten_set_main_loop_arg(func: CallbackFunc, arg: ?*anyopaque, fps: i32, simulate_infinite_loop: i32) void;
extern fn emscripten_pause_main_loop() void;
extern fn emscripten_resume_main_loop() void;
extern fn emscripten_cancel_main_loop() void;

extern fn emscripten_set_socket_error_callback(user_data: ?*anyopaque, error_callback: SocketErrorCallback) void;
extern fn emscripten_set_socket_open_callback(user_data: ?*anyopaque, error_callback: SocketCallback) void;
extern fn emscripten_set_socket_listen_callback(user_data: ?*anyopaque, error_callback: SocketCallback) void;
extern fn emscripten_set_socket_connection_callback(user_data: ?*anyopaque, error_callback: SocketCallback) void;
extern fn emscripten_set_socket_message_callback(user_data: ?*anyopaque, error_callback: SocketCallback) void;
extern fn emscripten_set_socket_close_callback(user_data: ?*anyopaque, error_callback: SocketCallback) void;

//TODO:
// void _emscripten_push_main_loop_blocker(em_arg_callback_func func, void *arg, const char *name);
// void _emscripten_push_uncounted_main_loop_blocker(em_arg_callback_func func, void *arg, const char *name);
// #define emscripten_push_main_loop_blocker(func, arg) \
//   _emscripten_push_main_loop_blocker(func, arg, #func)
// #define emscripten_push_uncounted_main_loop_blocker(func, arg) \
//   _emscripten_push_uncounted_main_loop_blocker(func, arg, #func)

extern fn emscripten_set_main_loop_expected_blockers(num: i32) void;

extern fn emscripten_async_call(func: ArgCallbackFunc, arg: ?*anyopaque, millis: i32) void;

extern fn emscripten_exit_with_live_runtime(void) noreturn;
extern fn emscripten_force_exit(status: i32) noreturn;

extern fn emscripten_get_device_pixel_ratio(void) f64;

extern fn emscripten_get_window_title() [*:0]u8;
extern fn emscripten_set_window_title(char: [*:0]const u8) void;
extern fn emscripten_get_screen_size(width: *i32, height: *i32) void;
extern fn emscripten_hide_mouse(void) void;
// deprecated:
//extern fn emscripten_set_canvas_size(int width, int height) __attribute__((deprecated("This variant does not allow specifying the target canvas", "Use emscripten_set_canvas_element_size() instead"))) void;
//extern fn emscripten_get_canvas_size(int *width, int *height, int *isFullscreen) __attribute__((deprecated("This variant does not allow specifying the target canvas", "Use emscripten_get_canvas_element_size() and void emscripten_get_fullscreen_status() instead")));

extern fn emscripten_get_now(void) f64;
extern fn emscripten_random(void) f32;

// IDB

// TODO:
// typedef void (*em_idb_onload_func)(void*, void*, int);
// void emscripten_idb_async_load(const char *db_name, const char *file_id, void* arg, em_idb_onload_func onload, em_arg_callback_func onerror);
// void emscripten_idb_async_store(const char *db_name, const char *file_id, void* ptr, int num, void* arg, em_arg_callback_func onstore, em_arg_callback_func onerror);
// void emscripten_idb_async_delete(const char *db_name, const char *file_id, void* arg, em_arg_callback_func ondelete, em_arg_callback_func onerror);
// typedef void (*em_idb_exists_func)(void*, int);
// void emscripten_idb_async_exists(const char *db_name, const char *file_id, void* arg, em_idb_exists_func oncheck, em_arg_callback_func onerror);

// IDB "sync"

// void emscripten_idb_load(const char *db_name, const char *file_id, void** pbuffer, int* pnum, int *perror);
// void emscripten_idb_store(const char *db_name, const char *file_id, void* buffer, int num, int *perror);
// void emscripten_idb_delete(const char *db_name, const char *file_id, int *perror);
// void emscripten_idb_exists(const char *db_name, const char *file_id, int* pexists, int *perror);

// void emscripten_idb_load_blob(const char *db_name, const char *file_id, int* pblob, int *perror);
// void emscripten_idb_store_blob(const char *db_name, const char *file_id, void* buffer, int num, int *perror);
// void emscripten_idb_read_from_blob(int blob, int start, int num, void* buffer);
// void emscripten_idb_free_blob(int blob);

// other async utilities

// int emscripten_run_preload_plugins(const char* file, em_str_callback_func onload, em_str_callback_func onerror);

// typedef void (*em_run_preload_plugins_data_onload_func)(void*, const char*);
// void emscripten_run_preload_plugins_data(char* data, int size, const char *suffix, void *arg, em_run_preload_plugins_data_onload_func onload, em_arg_callback_func onerror);

// void emscripten_lazy_load_code(void);

// show an error on some renamed methods
// #define emscripten_async_prepare(...) _Pragma("GCC error(\"emscripten_async_prepare has been replaced by emscripten_run_preload_plugins\")")
// #define emscripten_async_prepare_data(...) _Pragma("GCC error(\"emscripten_async_prepare_data has been replaced by emscripten_run_preload_plugins_data\")")

// worker APIs

// typedef int worker_handle;

// worker_handle emscripten_create_worker(const char *url);
// void emscripten_destroy_worker(worker_handle worker);

// typedef void (*em_worker_callback_func)(char*, int, void*);
// void emscripten_call_worker(worker_handle worker, const char *funcname, char *data, int size, em_worker_callback_func callback, void *arg);
// void emscripten_worker_respond(char *data, int size);
// void emscripten_worker_respond_provisionally(char *data, int size);

// int emscripten_get_worker_queue_size(worker_handle worker);

// misc.

extern fn emscripten_get_compiler_setting(name: [*:0]const u8) c_long;
extern fn emscripten_has_asyncify(void) c_int;

extern fn emscripten_debugger() void;

// Forward declare FILE from musl libc headers to avoid needing to #include <stdio.h> from emscripten.h
//struct _IO_FILE;
//typedef struct _IO_FILE FILE;
pub const FILE = anyopaque;

extern fn emscripten_get_preloaded_image_data(path: [*:0]const u8, w: *i32, h: i32) [*:0]u8;
extern fn emscripten_get_preloaded_image_data_from_FILE(file: *FILE, w: *i32, h: *i32) [*:0]u8;

pub const EmLog = enum(i32) {
    console = 1, // EM_LOG_CONSOLE
    warn = 2, // EM_LOG_WARN
    err = 4, // EM_LOG_ERROR
    c_stack = 8, // EM_LOG_C_STACK
    js_stack = 16, // EM_LOG_JS_STACK
    demangle = 32, // deprecated, // EM_LOG_DEMANGLE
    no_paths = 64, // EM_LOG_NO_PATHS
    func_params = 128, // EM_LOG_FUNC_PARAMS
    debug = 256, // EM_LOG_DEBUG
    info = 512, // EM_LOG_INFO
};

extern fn emscripten_log(flags: i32, format: [*:0]const u8, ...) void;

extern fn emscripten_get_callstack(flags: i32, out: [*:0]u8, maxbytes: i32) i32;

extern fn emscripten_print_double(x: f64, to: [*:0]u8, max: i32) i32;

// TODO:
// typedef void (*em_scan_func)(void*, void*);
// void emscripten_scan_registers(em_scan_func func);
// void emscripten_scan_stack(em_scan_func func);

// Asynchronous version of dlopen.  Since WebAssembly module loading in general
// is asynchronous the normal dlopen function can't be used in all situations.
// typedef void (*em_dlopen_callback)(void* handle, void* user_data);
// void emscripten_dlopen(const char *filename, int flags, void* user_data, em_dlopen_callback onsuccess, em_arg_callback_func onerror);

extern fn emscripten_throw_number(number: f64) void;
extern fn emscripten_throw_string(utf8String: [*:0]const u8) void;

extern fn emscripten_sleep(ms: u32) void;
