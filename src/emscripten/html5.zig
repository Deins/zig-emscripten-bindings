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
    ctrlKey: EmBool,
    shiftKey: EmBool,
    altKey: EmBool,
    metaKey: EmBool,
    repeat: EmBool,
    charCode: u32,
    keyCode: u32,
    which: u32,
    key: [SHORT_STRING_LEN_BYTES]u8,
    code: [SHORT_STRING_LEN_BYTES]u8,
    charValue: [SHORT_STRING_LEN_BYTES]u8,
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
    screenX: i32,
    screenY: i32,
    clientX: i32,
    clientY: i32,
    ctrlKey: EmBool,
    shiftKey: EmBool,
    altKey: EmBool,
    metaKey: EmBool,
    button: u16,
    buttons: u16,
    movementX: i32,
    movementY: i32,
    targetX: i32,
    targetY: i32,
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
    deltaX: f64,
    deltaY: f64,
    deltaZ: f64,
    deltaMode: u32,
};

pub const WheelCallbackFunc = *const fn (event_type: i32, wheel_event: *const WheelEvent, user_data: ?*anyopaque) EmBool; // em_wheel_callback_func
extern fn emscripten_set_wheel_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callbacl: WheelCallbackFunc, target_thread: pthread_t) Result;

pub const UiEvent = struct {
    detail: i64,
    documentBodyClientWidth: i32,
    documentBodyClientHeight: i32,
    windowInnerWidth: i32,
    windowInnerHeight: i32,
    windowOuterWidth: i32,
    windowOuterHeight: i32,
    scrollTop: i32,
    scrollLeft: i32,
};

pub const UiCallbackFunc = *const fn (event_type: i32, event: *const UiEvent, user_data: ?*anyopaque) EmBool; // em_ui_callback_func
extern fn emscripten_set_resize_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: UiCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_scroll_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, callback: UiCallbackFunc, target_thread: pthread_t) Result;

pub const FocusEvent = extern struct {
    nodeName: [LONG_STRING_LEN_BYTES]u8,
    id: [LONG_STRING_LEN_BYTES]u8,
};

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

pub const DeviceOrientationCallbackFunc = *const fn (event_type: i32, event: *const FocusEvent, user_data: ?*anyopaque) EmBool; // em_deviceorientation_callback_func
extern fn emscripten_set_deviceorientation_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: DeviceOrientationCallbackFunc, target_thread: pthread_t) Result;

extern fn emscripten_get_deviceorientation_status(orientationState: DeviceOrientationEvent) Result;

const DEVICE_MOTION_EVENT_SUPPORTS_ACCELERATION = 0x01;
const DEVICE_MOTION_EVENT_SUPPORTS_ACCELERATION_INCLUDING_GRAVITY = 0x02;
const DEVICE_MOTION_EVENT_SUPPORTS_ROTATION_RATE = 0x04;

const DeviceMotionEvent = extern struct {
    accelerationX: f64,
    accelerationY: f64,
    accelerationZ: f64,
    accelerationIncludingGravityX: f64,
    accelerationIncludingGravityY: f64,
    accelerationIncludingGravityZ: f64,
    rotationRateAlpha: f64,
    rotationRateBeta: f64,
    rotationRateGamma: f64,
    supportedFields: i32,
};

pub const DeviceMotionCallbackFunc = *const fn (event_type: i32, event: *const DeviceMotionEvent, user_data: ?*anyopaque) EmBool; // em_devicemotion_callback_func
extern fn emscripten_set_devicemotion_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: DeviceMotionCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_devicemotion_status(motionState: *DeviceMotionEvent) Result;

pub const ORIENTATION_PORTRAIT_PRIMARY = 1; // EMSCRIPTEN_ORIENTATION_PORTRAIT_PRIMARY
pub const ORIENTATION_PORTRAIT_SECONDARY = 2; // EMSCRIPTEN_ORIENTATION_PORTRAIT_SECONDARY
pub const ORIENTATION_LANDSCAPE_PRIMARY = 4; // EMSCRIPTEN_ORIENTATION_LANDSCAPE_PRIMARY
pub const ORIENTATION_LANDSCAPE_SECONDARY = 8; // EMSCRIPTEN_ORIENTATION_LANDSCAPE_SECONDARY

pub const OrientationChangeEvent = extern struct {
    orientationIndex: i32,
    orientationAngle: i32,
};

pub const OrientationChangeCallbackFunc = *const fn (event_type: i32, event: *const OrientationChangeEvent, user_data: ?*anyopaque) EmBool; // em_orientationchange_callback_func
extern fn emscripten_set_orientationchange_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: OrientationChangeCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_orientation_status(orientationStatus: *OrientationChangeEvent) Result;
extern fn emscripten_lock_orientation(allowedOrientations: i32) Result;
extern fn emscripten_unlock_orientation(void) Result;

pub const FullscreenChangeEvent = struct {
    isFullscreen: EmBool,
    fullscreenEnabled: EmBool,
    nodeName: [LONG_STRING_LEN_BYTES]u8,
    id: [LONG_STRING_LEN_BYTES]u8,
    elementWidth: i32,
    elementHeight: i32,
    screenWidth: i32,
    screenHeight: i32,
};

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
    scaleMode: FullscreenScale,
    canvasResolutionScaleMode: FullscreenCanvasScale,
    filteringMode: FullscreenFiltering,
    canvasResizedCallback: CanvasResizedCallback,
    canvasResizedCallbackUserData: ?*anyopaque,
    canvasResizedCallbackTargetThread: pthread_t,
};

extern fn emscripten_request_fullscreen(target: [*:0]const u8, deferUntilInEventHandler: EmBool) Result;
extern fn emscripten_request_fullscreen_strategy(target: [*:0]const u8, deferUntilInEventHandler: EmBool, fullscreenStrategy: *const FullscreenStrategy) Result;

extern fn emscripten_exit_fullscreen(void) Result;

extern fn emscripten_enter_soft_fullscreen(target: [*:0]const u8, fullscreenStrategy: *const FullscreenStrategy) Result;

extern fn emscripten_exit_soft_fullscreen(void) Result;

const PointerlockChangeEvent = extern struct {
    isActive: EmBool,
    nodeName: [LONG_STRING_LEN_BYTES]u8,
    id: [LONG_STRING_LEN_BYTES]u8,
};

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
    visibilityState: i32,
};

pub const VisibilityChangeCallbackFunc = *const fn (event_type: i32, event: *const VisibilityChangeEvent, user_data: ?*anyopaque) EmBool; // em_visibilitychange_callback_func
extern fn emscripten_set_visibilitychange_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: VisibilityChangeCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_get_visibility_status(visibilityStatus: *VisibilityChangeEvent) Result;

pub const TouchPoint = extern struct {
    identifier: c_long,
    screenX: c_long,
    screenY: c_long,
    clientX: c_long,
    clientY: c_long,
    pageX: c_long,
    pageY: c_long,
    isChanged: EmBool,
    onTarget: EmBool,
    targetX: c_long,
    targetY: c_long,
    // canvasX and canvasY are deprecated - there no longer exists a Module['canvas'] object, so canvasX/Y are no longer reported (register a listener on canvas directly to get canvas coordinates, or translate manually)
    _dontuse_canvasX: c_long,
    _dontuse_canvasY: c_long,
};

pub const TouchEvent = extern struct {
    timestamp: f64,
    numTouches: i32,
    ctrlKey: EmBool,
    shiftKey: EmBool,
    altKey: EmBool,
    metaKey: EmBool,
    touches: [32]TouchPoint,
};

pub const TouchCallbackFunc = *const fn (event_type: i32, event: *const TouchEvent, user_data: ?*anyopaque) EmBool; // em_touch_callback_func
extern fn emscripten_set_touchstart_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_touchend_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_touchmove_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_touchcancel_callback_on_thread(target: [*:0]const u8, user_data: *anyopaque, use_capture: EmBool, TouchCallbackFunc, target_thread: pthread_t) Result;

pub const GamepadEvent = extern struct {
    timestamp: f64,
    numAxes: i32,
    numButtons: i32,
    axis: [64]f64,
    analogButton: [64]f64,
    digitalButton: [64]EmBool,
    connected: EmBool,
    index: c_long,
    id: [MEDIUM_STRING_LEN_BYTES]u8,
    mapping: [MEDIUM_STRING_LEN_BYTES]u8,
};

pub const GamepadCallbackFunc = *const fn (event_type: i32, event: *const GamepadEvent, user_data: ?*anyopaque) EmBool; // em_gamepad_callback_func
extern fn emscripten_set_gamepadconnected_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: GamepadCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_gamepaddisconnected_callback_on_thread(user_data: *anyopaque, use_capture: EmBool, callback: GamepadCallbackFunc, target_thread: pthread_t) Result;

extern fn emscripten_sample_gamepad_data(void) Result;
extern fn emscripten_get_num_gamepads(void) c_int;
extern fn emscripten_get_gamepad_status(index: i32, gamepadState: *GamepadEvent) Result;

pub const BatteryEvent = extern struct {
    chargingTime: f64,
    dischargingTime: f64,
    level: f64,
    charging: EmBool,
};

pub const BatteryCallbackFunc = *const fn (event_type: i32, event: *const BatteryEvent, user_data: ?*anyopaque) EmBool; // em_battery_callback_func
extern fn emscripten_set_batterychargingchange_callback_on_thread(user_data: *anyopaque, callback: BatteryCallbackFunc, target_thread: pthread_t) Result;
extern fn emscripten_set_batterylevelchange_callback_on_thread(user_data: *anyopaque, callback: BatteryCallbackFunc, target_thread: pthread_t) Result;

extern fn emscripten_get_battery_status(batteryState: BatteryEvent) Result;

extern fn emscripten_vibrate(msecs: i32) Result;
extern fn emscripten_vibrate_pattern(msecsArray: [*]i32, numEntries: i32) Result;

pub const BeforeUnloadCallback = *const fn (event_type: i32, event: ?*const anyopaque, user_data: ?*anyopaque) ?[*]const u8; // em_beforeunload_callback
extern fn emscripten_set_beforeunload_callback_on_thread(user_data: *anyopaque, callback: BeforeUnloadCallback, target_thread: pthread_t) Result;

// Sets the canvas.width & canvas.height properties.
extern fn emscripten_set_canvas_element_size(target: [*:0]const u8, width: i32, height: i32) Result;

// Returns the canvas.width & canvas.height properties.
extern fn emscripten_get_canvas_element_size(target: [*:0]const u8, width: *i32, height: *i32) Result;

extern fn emscripten_set_element_css_size(target: [*:0]const u8, width: f64, height: f64) Result;
extern fn emscripten_get_element_css_size(target: [*:0]const u8, width: *f64, height: *f64) Result;

extern fn emscripten_html5_remove_all_event_listeners(void) void;

pub const EM_CALLBACK_THREAD_CONTEXT_MAIN_BROWSER_THREAD = pthread_t{(0x1)}; // ((pthread_t)0x1)
pub const EM_CALLBACK_THREAD_CONTEXT_CALLING_THREAD = pthread_t{(0x2)}; // ((pthread_t)0x2)

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
