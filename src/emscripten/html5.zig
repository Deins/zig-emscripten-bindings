// This file defines Emscripten low-level glue bindings for interfacing with HTML5 APIs
//
// Documentation for the public APIs defined in this file must be updated in:
//    site/source/docs/api_reference/html5.h.rst
// A prebuilt local version of the documentation is available at:
//    site/build/text/docs/api_reference/html5.h.txt
// You can also build docs locally as HTML or other formats in site/
// An online HTML version (which may be of a different version of Emscripten)
//    is up at http://kripken.github.io/emscripten-site/docs/api_reference/html5.h.html
//

const em_types = @import("em_types.zig");
const EmBool = em_types.EmBool;
const pthread_t = u64;

pub const EventType = enum(u32) {
    keypress = 1, // EMSCRIPTEN_EVENT_KEYPRESS
    keydown = 2, // EMSCRIPTEN_EVENT_KEYDOWN
    keyup = 3, // EMSCRIPTEN_EVENT_KEYUP
    click = 4, // EMSCRIPTEN_EVENT_CLICK
    mousedown = 5, // EMSCRIPTEN_EVENT_MOUSEDOWN
    mouseup = 6, // EMSCRIPTEN_EVENT_MOUSEUP
    dblclick = 7, // EMSCRIPTEN_EVENT_DBLCLICK
    mousemove = 8, // EMSCRIPTEN_EVENT_MOUSEMOVE
    wheel = 9, // EMSCRIPTEN_EVENT_WHEEL
    resize = 10, // EMSCRIPTEN_EVENT_RESIZE
    scroll = 11, // EMSCRIPTEN_EVENT_SCROLL
    blur = 12, // EMSCRIPTEN_EVENT_BLUR
    focus = 13, // EMSCRIPTEN_EVENT_FOCUS
    focusin = 14, // EMSCRIPTEN_EVENT_FOCUSIN
    focusout = 15, // EMSCRIPTEN_EVENT_FOCUSOUT
    deviceorientation = 16, // EMSCRIPTEN_EVENT_DEVICEORIENTATION
    devicemotion = 17, // EMSCRIPTEN_EVENT_DEVICEMOTION
    orientationchange = 18, // EMSCRIPTEN_EVENT_ORIENTATIONCHANGE
    fullscreenchange = 19, // EMSCRIPTEN_EVENT_FULLSCREENCHANGE
    pointerlockchange = 20, // EMSCRIPTEN_EVENT_POINTERLOCKCHANGE
    visibilitychange = 21, // EMSCRIPTEN_EVENT_VISIBILITYCHANGE
    touchstart = 22, // EMSCRIPTEN_EVENT_TOUCHSTART
    touchend = 23, // EMSCRIPTEN_EVENT_TOUCHEND
    touchmove = 24, // EMSCRIPTEN_EVENT_TOUCHMOVE
    touchcancel = 25, // EMSCRIPTEN_EVENT_TOUCHCANCEL
    gamepadconnected = 26, // EMSCRIPTEN_EVENT_GAMEPADCONNECTED
    gamepaddisconnected = 27, // EMSCRIPTEN_EVENT_GAMEPADDISCONNECTED
    beforeunload = 28, // EMSCRIPTEN_EVENT_BEFOREUNLOAD
    batterychargingchange = 29, // EMSCRIPTEN_EVENT_BATTERYCHARGINGCHANGE
    batterylevelchange = 30, // EMSCRIPTEN_EVENT_BATTERYLEVELCHANGE
    webglcontextlost = 31, // EMSCRIPTEN_EVENT_WEBGLCONTEXTLOST
    webglcontextrestored = 32, // EMSCRIPTEN_EVENT_WEBGLCONTEXTRESTORED
    mouseenter = 33, // EMSCRIPTEN_EVENT_MOUSEENTER
    mouseleave = 34, // EMSCRIPTEN_EVENT_MOUSELEAVE
    mouseover = 35, // EMSCRIPTEN_EVENT_MOUSEOVER
    mouseout = 36, // EMSCRIPTEN_EVENT_MOUSEOUT
    canvasresized = 37, // EMSCRIPTEN_EVENT_CANVASRESIZED
    pointerlockerror = 38, // EMSCRIPTEN_EVENT_POINTERLOCKERROR
};

pub const Result = enum(i32) {
    success = 0, // EMSCRIPTEN_RESULT_SUCCESS
    deferred = 1, // EMSCRIPTEN_RESULT_DEFERRED
    not_supported = -1, // EMSCRIPTEN_RESULT_NOT_SUPPORTED
    failed_not_deferred = -2, // EMSCRIPTEN_RESULT_FAILED_NOT_DEFERRED
    invalid_target = -3, // EMSCRIPTEN_RESULT_INVALID_TARGET
    unknown_target = -4, // EMSCRIPTEN_RESULT_UNKNOWN_TARGET
    invalid_param = -5, // EMSCRIPTEN_RESULT_INVALID_PARAM
    failed = -6, // EMSCRIPTEN_RESULT_FAILED
    no_data = -7, // EMSCRIPTEN_RESULT_NO_DATA
    timed_out = -8, // EMSCRIPTEN_RESULT_TIMED_OUT
};

pub const TARGET_INVALID = 0; // EMSCRIPTEN_EVENT_TARGET_INVALID
pub const TARGET_DOCUMENT = @intToPtr(*const u8, 1); // EMSCRIPTEN_EVENT_TARGET_DOCUMENT
pub const TARGET_WINDOW = @intToPtr(*const u8, 2); // EMSCRIPTEN_EVENT_TARGET_WINDOW
pub const TARGET_SCREEN = @intToPtr(*const u8, 3); // EMSCRIPTEN_EVENT_TARGET_SCREEN

const KeyLocation = enum(i32) {
    standard = 0x00, // DOM_KEY_LOCATION_STANDARD
    left = 0x01, // DOM_KEY_LOCATION_LEFT
    right = 0x02, // DOM_KEY_LOCATION_RIGHT
    numpad = 0x03, // DOM_KEY_LOCATION_NUMPAD
};

const SHORT_STRING_LEN_BYTES = 32; // EM_HTML5_SHORT_STRING_LEN_BYTES
const MEDIUM_STRING_LEN_BYTES = 64; // EM_HTML5_MEDIUM_STRING_LEN_BYTES
const LONG_STRING_LEN_BYTES = 128; // EM_HTML5_LONG_STRING_LEN_BYTES

const KeyboardEvent = extern struct {
    timestamp: u64,
    location: u32,
    ctrl_key: EmBool,
    shift_key: EmBool,
    alt_key: EmBool,
    meta_key: EmBool,
    repeat: EmBool,
    char_code: u32,
    key_code: u32,
    which: u32,
    key: [SHORT_STRING_LEN_BYTES]u8,
    code: [SHORT_STRING_LEN_BYTES]u8,
    char_value: [SHORT_STRING_LEN_BYTES]u8,
    locale: [SHORT_STRING_LEN_BYTES]u8,
};

pub const KeyCallbackFunc = *const fn (event_type: i32, mouse_event: *const KeyboardEvent, user_data: ?*anyopaque) EmBool; // em_key_callback_func
pub const setKeyPressCallbackOnThread = emscripten_set_keypress_callback_on_thread;
pub const setKeyDownCallbackOnThread = emscripten_set_keydown_callback_on_thread;
pub const setKeyUpCallbackOnThread = emscripten_set_keyup_callback_on_thread;
extern fn emscripten_set_keypress_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: KeyCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_keydown_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: KeyCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_keyup_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: KeyCallbackFunc, target_thread: pthread_t) Result;

pub const MouseEvent = extern struct {
    timestamp: f64,
    screen_x: i32,
    screen_y: i32,
    client_x: i32,
    client_y: i32,
    ctrl_key: EmBool,
    shift_key: EmBool,
    alt_key: EmBool,
    meta_key: EmBool,
    button: u16,
    buttons: u16,
    movement_x: i32,
    movement_y: i32,
    target_x: i32,
    target_y: i32,
    // canvasX and canvasY are deprecated - there no longer exists a Module['canvas'] object, so canvasX/Y are no longer reported (register a listener on canvas directly to get canvas coordinates, or translate manually)
    _dontuse_canvasX: i32,
    _dontuse_canvasY: i32,
    _dontuse_padding: i32,
};

pub const MouseCallbackFunc = *const fn (event_type: i32, key_event: *const MouseEvent, user_data: ?*anyopaque) EmBool; // em_mouse_callback_func
pub const setClickCallbackOnThread = emscripten_set_click_callback_on_thread;
pub const setMousedownCallbackOnThread = emscripten_set_mousedown_callback_on_thread;
pub const setMouseupCallbackOnThread = emscripten_set_mouseup_callback_on_thread;
pub const setDblclickCallbackOnThread = emscripten_set_dblclick_callback_on_thread;
pub const setMousemoveCallbackOnThread = emscripten_set_mousemove_callback_on_thread;
pub const setMouseenterCallbackOnThread = emscripten_set_mouseenter_callback_on_thread;
pub const setMouseleaveCallbackOnThread = emscripten_set_mouseleave_callback_on_thread;
pub const setMouseoverCallbackOnThread = emscripten_set_mouseover_callback_on_thread;
pub const setMouseoutCallbackOnThread = emscripten_set_mouseout_callback_on_thread;
extern fn emscripten_set_click_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_mousedown_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_mouseup_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_dblclick_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_mousemove_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_mouseenter_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_mouseleave_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_mouseover_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_mouseout_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: MouseCallbackFunc, target_thread: pthread_t) Result;

pub const getMouseStatus = emscripten_get_mouse_status;
extern fn emscripten_get_mouse_status(mouseState: MouseEvent) Result;

pub const DOM_DELTA_PIXEL = 0x00;
pub const DOM_DELTA_LINE = 0x01;
pub const DOM_DELTA_PAGE = 0x02;

pub const WheelEvent = extern struct {
    mouse: MouseEvent,
    delta_x: f64,
    delta_y: f64,
    delta_z: f64,
    delta_mode: u32,
};

pub const setWheelCallbackOnThread = emscripten_set_wheel_callback_on_thread;
pub const WheelCallbackFunc = *const fn (event_type: i32, wheel_event: *const WheelEvent, user_data: ?*anyopaque) EmBool; // em_wheel_callback_func
extern fn emscripten_set_wheel_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callbacl: WheelCallbackFunc, target_thread: pthread_t) Result;

pub const UiEvent = struct {
    detail: i64,
    document_body_client_width: i32,
    document_body_client_height: i32,
    window_inner_width: i32,
    window_inner_height: i32,
    window_outer_width: i32,
    window_outer_height: i32,
    scroll_top: i32,
    scroll_left: i32,
};

pub const setResizeCallbackOnThread = emscripten_set_resize_callback_on_thread;
pub const setScrollCallbackOnThread = emscripten_set_scroll_callback_on_thread;
pub const UiCallbackFunc = *const fn (event_type: i32, event: *const UiEvent, user_data: ?*anyopaque) EmBool; // em_ui_callback_func
extern fn emscripten_set_resize_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: UiCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_scroll_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: UiCallbackFunc, target_thread: pthread_t) Result;

pub const FocusEvent = extern struct {
    node_name: [LONG_STRING_LEN_BYTES]u8,
    id: [LONG_STRING_LEN_BYTES]u8,
};

pub const setBlurCallbackOnThread = emscripten_set_blur_callback_on_thread;
pub const setFocusCallbackOnThread = emscripten_set_focus_callback_on_thread;
pub const setFocusInCallbackOnThread = emscripten_set_focusin_callback_on_thread;
pub const setFocusOutCallbackOnThread = emscripten_set_focusout_callback_on_thread;
pub const FocusCallbackFunc = *const fn (event_type: i32, event: *const FocusEvent, user_data: ?*anyopaque) EmBool; // em_focus_callback_func
extern fn emscripten_set_blur_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: FocusCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_focus_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: FocusCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_focusin_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: FocusCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_focusout_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: FocusCallbackFunc, target_thread: pthread_t) Result;

pub const DeviceOrientationEvent = extern struct {
    alpha: f64,
    beta: f64,
    gamma: f64,
    absolute: EmBool,
};

pub const setDeviceOrientationCallbackOnThread = emscripten_set_deviceorientation_callback_on_thread;
pub const getDeviceOrientationStatus = emscripten_get_deviceorientation_status;
pub const DeviceOrientationCallbackFunc = *const fn (event_type: i32, event: *const FocusEvent, user_data: ?*anyopaque) EmBool; // em_deviceorientation_callback_func
extern fn emscripten_set_deviceorientation_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: DeviceOrientationCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_deviceorientation_status(orientationState: DeviceOrientationEvent) Result;

pub const DEVICE_MOTION_EVENT_SUPPORTS_ACCELERATION = 0x01;
pub const DEVICE_MOTION_EVENT_SUPPORTS_ACCELERATION_INCLUDING_GRAVITY = 0x02;
pub const DEVICE_MOTION_EVENT_SUPPORTS_ROTATION_RATE = 0x04;

const DeviceMotionEvent = extern struct {
    acceleration_x: f64,
    acceleration_y: f64,
    acceleration_z: f64,
    acceleration_including_gravity_x: f64,
    acceleration_including_gravity_y: f64,
    acceleration_including_gravity_z: f64,
    rotation_rate_alpha: f64,
    rotation_rate_beta: f64,
    rotation_rate_gamma: f64,
    supported_dields: i32,
};

pub const setDeviceMotionCallback = emscripten_set_devicemotion_callback_on_thread;
pub const getDeviceMotionStatus = emscripten_get_devicemotion_status;
pub const DeviceMotionCallbackFunc = *const fn (event_type: i32, event: *const DeviceMotionEvent, user_data: ?*anyopaque) EmBool; // em_devicemotion_callback_func
extern fn emscripten_set_devicemotion_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: DeviceMotionCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_devicemotion_status(motionState: *DeviceMotionEvent) Result;

pub const ORIENTATION_PORTRAIT_PRIMARY = 1; // EMSCRIPTEN_ORIENTATION_PORTRAIT_PRIMARY
pub const ORIENTATION_PORTRAIT_SECONDARY = 2; // EMSCRIPTEN_ORIENTATION_PORTRAIT_SECONDARY
pub const ORIENTATION_LANDSCAPE_PRIMARY = 4; // EMSCRIPTEN_ORIENTATION_LANDSCAPE_PRIMARY
pub const ORIENTATION_LANDSCAPE_SECONDARY = 8; // EMSCRIPTEN_ORIENTATION_LANDSCAPE_SECONDARY

pub const OrientationChangeEvent = extern struct {
    orientation_index: i32,
    orientation_angle: i32,
};

pub const setOrientationChangeCallback = emscripten_set_orientationchange_callback_on_thread;
pub const getOrientationStatus = emscripten_get_orientation_status;
pub const unlockOrientation = emscripten_lock_orientation;
pub const lockOrientation = emscripten_unlock_orientation;
pub const OrientationChangeCallbackFunc = *const fn (event_type: i32, event: *const OrientationChangeEvent, user_data: ?*anyopaque) EmBool; // em_orientationchange_callback_func
extern fn emscripten_set_orientationchange_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: OrientationChangeCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_orientation_status(orientationStatus: *OrientationChangeEvent) Result;
extern fn emscripten_lock_orientation(allowedOrientations: i32) Result;
extern fn emscripten_unlock_orientation(void) Result;

pub const FullscreenChangeEvent = struct {
    is_fullscreen: EmBool,
    fullscreen_enabled: EmBool,
    node_name: [LONG_STRING_LEN_BYTES]u8,
    id: [LONG_STRING_LEN_BYTES]u8,
    element_width: i32,
    element_height: i32,
    screen_width: i32,
    screen_height: i32,
};

pub const setFullscreenChangeCallbackOnThread = emscripten_set_fullscreenchange_callback_on_thread;
pub const getFullscreenStatus = emscripten_get_fullscreen_status;
pub const FullscreenChangeCallbackFunc = *const fn (event_type: i32, event: *const FullscreenChangeEvent, user_data: ?*anyopaque) EmBool; // em_fullscreenchange_callback_func
extern fn emscripten_set_fullscreenchange_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: FullscreenChangeCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_fullscreen_status(fullscreenStatus: *FullscreenChangeEvent) Result;

pub const FullscreenScale = enum(i32) {
    default = 0, // EMSCRIPTEN_FULLSCREEN_SCALE_DEFAULT
    stretch = 1, // EMSCRIPTEN_FULLSCREEN_SCALE_STRETCH
    aspect = 2, // EMSCRIPTEN_FULLSCREEN_SCALE_ASPECT
    center = 3, // EMSCRIPTEN_FULLSCREEN_SCALE_CENTER
};

pub const FullscreenCanvasScale = enum(i32) {
    none = 0, // EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE_NONE
    stddef = 1, // EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE_STDDEF
    hidef = 2, // EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE_HIDEF
};

pub const FullscreenFiltering = enum(i32) {
    default = 0, // EMSCRIPTEN_FULLSCREEN_FILTERING_DEFAULT
    nearest = 1, // EMSCRIPTEN_FULLSCREEN_FILTERING_NEAREST
    bilinear = 2, // EMSCRIPTEN_FULLSCREEN_FILTERING_BILINEAR
};
pub const CanvasResizedCallback = *const fn (event_type: i32, reserved: ?*anyopaque, user_data: *anyopaque) EmBool;

pub const FullscreenStrategy = extern struct {
    scale_mode: FullscreenScale,
    canvas_resolution_scale_mode: FullscreenCanvasScale,
    filtering_mode: FullscreenFiltering,
    canvas_resized_callback: CanvasResizedCallback,
    canvas_resized_callback_user_data: ?*anyopaque,
    canvas_resized_callback_target_thread: pthread_t,
};


pub const requestFullscreen = emscripten_request_fullscreen;
pub const requestFullscreenStrategy = emscripten_request_fullscreen_strategy;
pub const exitFullscreen = emscripten_exit_fullscreen;
pub const enterSoftFullscreen = emscripten_enter_soft_fullscreen;
pub const exitSoftFullscreen = emscripten_exit_soft_fullscreen;
extern fn emscripten_request_fullscreen(target: [*:0]const u8, deferUntilInEventHandler: EmBool) Result;
extern fn emscripten_request_fullscreen_strategy(target: [*:0]const u8, deferUntilInEventHandler: EmBool, fullscreenStrategy: *const FullscreenStrategy) Result;
extern fn emscripten_exit_fullscreen(void) Result;
extern fn emscripten_enter_soft_fullscreen(target: [*:0]const u8, fullscreenStrategy: *const FullscreenStrategy) Result;
extern fn emscripten_exit_soft_fullscreen(void) Result;

const PointerlockChangeEvent = extern struct {
    is_active: EmBool,
    node_name: [LONG_STRING_LEN_BYTES]u8,
    id: [LONG_STRING_LEN_BYTES]u8,
};

pub const setPointerlockChangeCallbackOnThread = emscripten_set_pointerlockchange_callback_on_thread;
pub const setPointerlockErrorCallbackOnThread = emscripten_set_pointerlockerror_callback_on_thread;
pub const getPointerlockStatus = emscripten_get_pointerlock_status;
pub const requestPointerlock = emscripten_request_pointerlock;
pub const exitPointerlock = emscripten_exit_pointerlock;
pub const PointerlockChangeCallbackFunc = *const fn (event_type: i32, event: *const PointerlockChangeEvent, user_data: ?*anyopaque) EmBool; // em_pointerlockchange_callback_func
extern fn emscripten_set_pointerlockchange_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: PointerlockChangeCallbackFunc, target_thread: pthread_t) Result;
pub const PointerlockErrorCallbackFunc = *const fn (event_type: i32, reserved: *const anyopaque, user_data: ?*anyopaque) EmBool; // em_pointerlockerror_callback_func
extern fn emscripten_set_pointerlockerror_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: PointerlockErrorCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_pointerlock_status(pointerlockStatus: *PointerlockChangeEvent) Result;
extern fn emscripten_request_pointerlock(target: [*:0]const u8, deferUntilInEventHandler: EmBool) Result;
extern fn emscripten_exit_pointerlock(void) Result;

pub const EMSCRIPTEN_VISIBILITY_HIDDEN = 0;
pub const EMSCRIPTEN_VISIBILITY_VISIBLE = 1;
pub const EMSCRIPTEN_VISIBILITY_PRERENDER = 2;
pub const EMSCRIPTEN_VISIBILITY_UNLOADED = 3;

pub const VisibilityChangeEvent = extern struct {
    hidden: EmBool,
    visibility_state: i32,
};

pub const setVisibilityChangeCallbackOnThread = emscripten_set_visibilitychange_callback_on_thread;
pub const getVisibilityStatus = emscripten_get_visibility_status;
pub const VisibilityChangeCallbackFunc = *const fn (event_type: i32, event: *const VisibilityChangeEvent, user_data: ?*anyopaque) EmBool; // em_visibilitychange_callback_func
extern fn emscripten_set_visibilitychange_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: VisibilityChangeCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_visibility_status(visibilityStatus: *VisibilityChangeEvent) Result;

pub const TouchPoint = extern struct {
    identifier: c_long,
    screen_x: c_long,
    screen_y: c_long,
    client_x: c_long,
    client_y: c_long,
    page_x: c_long,
    page_y: c_long,
    is_changed: EmBool,
    on_target: EmBool,
    target_x: c_long,
    target_y: c_long,
    // canvasX and canvasY are deprecated - there no longer exists a Module['canvas'] object, so canvasX/Y are no longer reported (register a listener on canvas directly to get canvas coordinates, or translate manually)
    _dontuse_canvasX: c_long,
    _dontuse_canvasY: c_long,
};

pub const TouchEvent = extern struct {
    timestamp: f64,
    num_touches: i32,
    ctrl_key: EmBool,
    shift_key: EmBool,
    alt_key: EmBool,
    meta_key: EmBool,
    touches: [32]TouchPoint,
};

pub const TouchCallbackFunc = *const fn (event_type: i32, event: *const TouchEvent, user_data: ?*anyopaque) EmBool; // em_touch_callback_func
extern fn emscripten_set_touchstart_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_touchend_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_touchmove_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_touchcancel_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;

pub const GamepadEvent = extern struct {
    timestamp: f64,
    num_axes: i32,
    num_buttons: i32,
    axis: [64]f64,
    analog_button: [64]f64,
    digital_button: [64]EmBool,
    connected: EmBool,
    index: c_long,
    id: [MEDIUM_STRING_LEN_BYTES]u8,
    mapping: [MEDIUM_STRING_LEN_BYTES]u8,
};

pub const setGamepadConnectedCallbackOnThread = emscripten_set_gamepadconnected_callback_on_thread;
pub const setGamepadDisconnectedCallbackOnThread = emscripten_set_gamepaddisconnected_callback_on_thread;
pub const sampleGamepadData = emscripten_sample_gamepad_data;
pub const getNumGamepads = emscripten_get_num_gamepads;
pub const getGamepadStatus = emscripten_get_gamepad_status;
pub const GamepadCallbackFunc = *const fn (event_type: i32, event: *const GamepadEvent, user_data: ?*anyopaque) EmBool; // em_gamepad_callback_func
extern fn emscripten_set_gamepadconnected_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: GamepadCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_gamepaddisconnected_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: GamepadCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_sample_gamepad_data(void) Result;
extern fn emscripten_get_num_gamepads(void) c_int;
extern fn emscripten_get_gamepad_status(index: i32, gamepadState: *GamepadEvent) Result;

pub const BatteryEvent = extern struct {
    charging_time: f64,
    discharging_time: f64,
    level: f64,
    charging: EmBool,
};

pub const setBatteryChargingChangeCallbackOnThread = emscripten_set_batterychargingchange_callback_on_thread;
pub const setBatteryLevelChangeCallbackOnThread = emscripten_set_batterylevelchange_callback_on_thread;
pub const getBatteryStatus = emscripten_get_battery_status;
pub const BatteryCallbackFunc = *const fn (event_type: i32, event: *const BatteryEvent, user_data: ?*anyopaque) EmBool; // em_battery_callback_func
extern fn emscripten_set_batterychargingchange_callback_on_thread(user_data: *anyopaque, callback: BatteryCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_batterylevelchange_callback_on_thread(user_data: *anyopaque, callback: BatteryCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_battery_status(batteryState: BatteryEvent) Result;

pub const vibrate = emscripten_vibrate;
pub const vibratePattern = emscripten_vibrate_pattern;
extern fn emscripten_vibrate(msecs: i32) Result;
extern fn emscripten_vibrate_pattern(msecsArray: [*]i32, numEntries: i32) Result;

pub const setBeforeUnloadCallbackOnThread = emscripten_set_beforeunload_callback_on_thread;
pub const BeforeUnloadCallback = *const fn (event_type: i32, event: ?*const anyopaque, user_data: ?*anyopaque) ?[*]const u8; // em_beforeunload_callback
extern fn emscripten_set_beforeunload_callback_on_thread(user_data: *anyopaque, callback: BeforeUnloadCallback, target_thread: pthread_t) Result;

// Sets the canvas.width & canvas.height properties.
pub const setCanvasElementSize = emscripten_set_canvas_element_size; 
extern fn emscripten_set_canvas_element_size(target: [*:0]const u8, width: i32, height: i32) Result;

// Returns the canvas.width & canvas.height properties.
pub const getCanvasElementSize = emscripten_get_canvas_element_size; 
extern fn emscripten_get_canvas_element_size(target: [*:0]const u8, width: *i32, height: *i32) Result;

pub const setElementCssSize = emscripten_set_element_css_size; 
pub const getElementCssSize = emscripten_get_element_css_size; 
extern fn emscripten_set_element_css_size(target: [*:0]const u8, width: f64, height: f64) Result;
extern fn emscripten_get_element_css_size(target: [*:0]const u8, width: *f64, height: *f64) Result;

pub const html5RemoveAllEventListeners = emscripten_html5_remove_all_event_listeners; 
extern fn emscripten_html5_remove_all_event_listeners(void) void;

pub const EM_CALLBACK_THREAD_CONTEXT_MAIN_BROWSER_THREAD = pthread_t{(0x1)}; // ((pthread_t)0x1)
pub const EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD = pthread_t{(0x2)}; // ((pthread_t)0x2)

// Forwardings
// #define emscripten_set_keypress_callback(target, userData, useCapture, callback)              emscripten_set_keypress_callback_on_thread(             (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_keydown_callback(target, userData, useCapture, callback)               emscripten_set_keydown_callback_on_thread(              (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_keyup_callback(target, userData, useCapture, callback)                 emscripten_set_keyup_callback_on_thread(                (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_click_callback(target, userData, useCapture, callback)                 emscripten_set_click_callback_on_thread(                (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_mousedown_callback(target, userData, useCapture, callback)             emscripten_set_mousedown_callback_on_thread(            (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_mouseup_callback(target, userData, useCapture, callback)               emscripten_set_mouseup_callback_on_thread(              (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_dblclick_callback(target, userData, useCapture, callback)              emscripten_set_dblclick_callback_on_thread(             (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_mousemove_callback(target, userData, useCapture, callback)             emscripten_set_mousemove_callback_on_thread(            (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_mouseenter_callback(target, userData, useCapture, callback)            emscripten_set_mouseenter_callback_on_thread(           (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_mouseleave_callback(target, userData, useCapture, callback)            emscripten_set_mouseleave_callback_on_thread(           (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_mouseover_callback(target, userData, useCapture, callback)             emscripten_set_mouseover_callback_on_thread(            (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_mouseout_callback(target, userData, useCapture, callback)              emscripten_set_mouseout_callback_on_thread(             (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_wheel_callback(target, userData, useCapture, callback)                 emscripten_set_wheel_callback_on_thread(                (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_resize_callback(target, userData, useCapture, callback)                emscripten_set_resize_callback_on_thread(               (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_scroll_callback(target, userData, useCapture, callback)                emscripten_set_scroll_callback_on_thread(               (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_blur_callback(target, userData, useCapture, callback)                  emscripten_set_blur_callback_on_thread(                 (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_focus_callback(target, userData, useCapture, callback)                 emscripten_set_focus_callback_on_thread(                (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_focusin_callback(target, userData, useCapture, callback)               emscripten_set_focusin_callback_on_thread(              (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_focusout_callback(target, userData, useCapture, callback)              emscripten_set_focusout_callback_on_thread(             (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_deviceorientation_callback(userData, useCapture, callback)             emscripten_set_deviceorientation_callback_on_thread(              (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_devicemotion_callback(userData, useCapture, callback)                  emscripten_set_devicemotion_callback_on_thread(                   (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_orientationchange_callback(userData, useCapture, callback)             emscripten_set_orientationchange_callback_on_thread(              (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_fullscreenchange_callback(target, userData, useCapture, callback)      emscripten_set_fullscreenchange_callback_on_thread(     (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_pointerlockchange_callback(target, userData, useCapture, callback)     emscripten_set_pointerlockchange_callback_on_thread(    (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_pointerlockerror_callback(target, userData, useCapture, callback)      emscripten_set_pointerlockerror_callback_on_thread(     (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_visibilitychange_callback(userData, useCapture, callback)              emscripten_set_visibilitychange_callback_on_thread(               (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_touchstart_callback(target, userData, useCapture, callback)            emscripten_set_touchstart_callback_on_thread(           (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_touchend_callback(target, userData, useCapture, callback)              emscripten_set_touchend_callback_on_thread(             (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_touchmove_callback(target, userData, useCapture, callback)             emscripten_set_touchmove_callback_on_thread(            (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_touchcancel_callback(target, userData, useCapture, callback)           emscripten_set_touchcancel_callback_on_thread(          (target), (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_gamepadconnected_callback(userData, useCapture, callback)              emscripten_set_gamepadconnected_callback_on_thread(               (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_gamepaddisconnected_callback(userData, useCapture, callback)           emscripten_set_gamepaddisconnected_callback_on_thread(            (userData), (useCapture), (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_batterychargingchange_callback(userData, callback)                     emscripten_set_batterychargingchange_callback_on_thread(          (userData),               (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_batterylevelchange_callback(userData, callback)                        emscripten_set_batterylevelchange_callback_on_thread(             (userData),               (callback), EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD)
// #define emscripten_set_beforeunload_callback(userData, callback)                              emscripten_set_beforeunload_callback_on_thread(                   (userData),               (callback), EM_CALLBACK_THREAD_CONTEXT_MAIN_BROWSER_THREAD)

pub const requestAnimationFrame = emscripten_request_animation_frame;
pub const cancelAnimationFrame = emscripten_cancel_animation_frame;
pub const requestAnimationFrameLoop = emscripten_request_animation_frame_loop;
pub const dateNow = emscripten_date_now;
pub const performanceNow = emscripten_performance_now;

pub const AnimationFrameCallback = *const fn (time: f64, user_data: *anyopaque) EmBool;
extern fn emscripten_request_animation_frame(cb: AnimationFrameCallback, user_data: *anyopaque) c_long;
extern fn emscripten_cancel_animation_frame(requestAnimationFrameId: c_long) void;
extern fn emscripten_request_animation_frame_loop(cb: AnimationFrameCallback, user_data: *anyopaque) void;

extern fn emscripten_date_now(void) f64;
extern fn emscripten_performance_now(void) f64;
