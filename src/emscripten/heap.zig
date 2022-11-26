pub const WASM_PAGE_SIZE = 65536;

pub const getSbrkPtr = emscripten_get_sbrk_ptr;
pub const resizeHeap = emscripten_resize_heap;
pub const getHeapSize = emscripten_get_heap_size;
pub const getHeapMax = emscripten_get_heap_max;
pub const builtinMemalign = emscripten_builtin_memalign;
pub const builtinMalloc = emscripten_builtin_malloc;
pub const builtinFree = emscripten_builtin_free;

// Returns a pointer to a memory location that contains the heap DYNAMICTOP
// variable (the end of the dynamic memory region)
extern fn emscripten_get_sbrk_ptr() *allowzero anyopaque;

// Attempts to geometrically or linearly increase the heap so that it
// grows to the new size of at least `requested_size` bytes. The heap size may
// be overallocated, see src/settings.js variables MEMORY_GROWTH_GEOMETRIC_STEP,
// MEMORY_GROWTH_GEOMETRIC_CAP and MEMORY_GROWTH_LINEAR_STEP. This function
// cannot be used to shrink the size of the heap.
extern fn emscripten_resize_heap(requested_size : usize) i32; // WARN: EM_IMPORT(emscripten_resize_heap) from c header was dropped!

// Returns the current size of the WebAssembly heap.
extern fn emscripten_get_heap_size() usize;

// Returns the max size of the WebAssembly heap.
extern fn emscripten_get_heap_max() usize;

// Direct access to the system allocator.  Use these to access that underlying
// allocator when intercepting/wrapping the allocator API.  Works with with both
// dlmalloc and emmalloc.
extern fn emscripten_builtin_memalign(alignment : usize, size : usize) ?* anyopaque;
extern fn emscripten_builtin_malloc(size : usize) ?* anyopaque;
extern fn emscripten_builtin_free(ptr : *anyopaque) void;
