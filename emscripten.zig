pub const allocator = @import("src/allocator.zig");

pub usingnamespace  @import("src/emscripten/em_types.zig");
pub const heap = @import("src/emscripten/heap.zig");
pub const console = @import("src/emscripten/console.zig");
pub usingnamespace @import("src/emscripten/html5.zig");


//==================================================================================
// Main functions from emscripten/emscripten.zig
//==================================================================================
pub usingnamespace @import("src/emscripten/emscripten.zig");

