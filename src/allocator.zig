const std = @import("std");
const emheap = @import("emscripten/heap.zig");

/// Direct access to the emscripten system allocator using emscripten_builtin_* allocation functions
/// At the moment doesn't support resize: builtin_* api no exposed resize, but maybe c realloc works
/// Works with with both dlmalloc and emmalloc.
pub const BuiltinAllocator = struct {
    const Self = @This();
    dummy : u32 = undefined,

    pub fn allocator(self: *Self) std.mem.Allocator {
        return std.mem.Allocator.init(self, alloc, std.mem.Allocator.NoResize(Self).noResize, free);
    }

    fn alloc(
        self: *Self,
        len: usize,
        ptr_align: u29,
        len_align: u29,
        return_address: usize,
    ) error{OutOfMemory}![]u8 {
        _ = self;
        _ = len_align;
        _ = return_address;
        const ptr = emheap.builtinMemalign(ptr_align, len) orelse return error.OutOfMemory;
        return @ptrCast([*]u8, ptr)[0..len];
    }

    fn free(
        self: *Self,
        buf: []u8,
        buf_align: u29,
        return_address: usize,
    ) void {
        _ = self;
        _ = buf_align;
        _ = return_address;
        return emheap.builtinFree(buf.ptr);
    }
};

/// EmmalocAllocator allocator
/// use with linker flag -sMALLOC=emmalloc
pub const EmmalocAllocator = struct {
    const Self = @This();
    dummy : u32 = undefined,

    pub fn allocator(self: *Self) std.mem.Allocator {
        return std.mem.Allocator.init(self, alloc, resize, free);
    }

    const emmalloc = @import ("emscripten/emmaloc.zig");
    pub const dumpMemoryRegions = emmalloc.dumpMemoryRegions;
    pub const usableSize = emmalloc.usableSize;
    pub const realloc = emmalloc.realloc;
    pub const reallocTry = emmalloc.reallocTry;
    pub const alignedRealloc = emmalloc.alignedRealloc;
    pub const alignedReallocUnitialized = emmalloc.alignedReallocUnitialized;
    pub const posixMemalign = emmalloc.posixMemalign;
    pub const trim = emmalloc.trim;
    pub const validateMemoryRegions = emmalloc.validateMemoryRegions;
    pub const dynamicHeapSize = emmalloc.dynamicHeapSize;
    pub const freeDynamicMemory = emmalloc.freeDynamicMemory;
    pub const unclaimedHeapMemory = emmalloc.unclaimedHeapMemory;
    pub const computeFreeDynamicMemoryFragmentationMap = emmalloc.computeFreeDynamicMemoryFragmentationMap;

    fn alloc(
        self: *Self,
        len: usize,
        ptr_align: u29,
        len_align: u29,
        return_address: usize,
    ) error{OutOfMemory}![]u8 {
        _ = self;
        _ = return_address;
        if (!std.math.isPowerOfTwo(ptr_align)) unreachable;
        const ptr = emmalloc.memalign(ptr_align, len) orelse return error.OutOfMemory;
        if (len_align == 0) return @ptrCast([*]u8, ptr)[0..len];
        const full_len = usableSize(ptr);
        return ptr[0..std.mem.alignBackwardAnyAlign(full_len, len_align)];
    }

    fn resize(
        self: *Self,
        buf: []u8,
        buf_align: u29,
        new_len: usize,
        len_align: u29,
        return_address: usize,
    ) ?usize {
        _ = self;
        _ = buf_align;
        _ = return_address;
        const ptr = emmalloc.reallocTry(buf.ptr, new_len);
        if (new_len > buf.len and ptr == null) return null;
        if (len_align == 0) return new_len;
        return std.mem.alignBackwardAnyAlign(usableSize(ptr), len_align);
    }

    fn free(
        self: *Self,
        buf: []u8,
        buf_align: u29,
        return_address: usize,
    ) void {
        _ = self;
        _ = buf_align;
        _ = return_address;
        return emmalloc.free(buf.ptr);
    }
};