pub const allocator = @import("src/allocator.zig");

pub const em_types = @import("src/emscripten/em_types.zig");
pub const EmBool = em_types.EmBool;
pub const heap = @import("src/emscripten/heap.zig");
pub const console = @import("src/emscripten/console.zig");

pub const core = @import("src/emscripten/emscripten.zig");
