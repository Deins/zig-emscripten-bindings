// emmalloc: A lightweight web-friendly memory allocator suitable for very small applications.
// Enable the usage of emmalloc by passing the linker flag -sMALLOC=emmalloc to the application.

// zig public interface for emmaloc_ functions
// NOTE: non emmalloc_* functions have been commented out
pub const dumpMemoryRegions = emmalloc_dump_memory_regions;
pub const memalign = emmalloc_memalign;
pub const malloc = emmalloc_malloc;
pub const usableSize = emmalloc_usable_size;
pub const free = emmalloc_free;
pub const realloc = emmalloc_realloc;
pub const reallocTry = emmalloc_realloc_try;
pub const reallocUninitialized = emmalloc_realloc_uninitialized;
pub const alignedRealloc = emmalloc_aligned_realloc;
pub const alignedReallocUnitialized = emmalloc_aligned_realloc_uninitialized;
pub const posixMemalign = emmalloc_posix_memalign;
pub const calloc = emmalloc_calloc;
pub const trim = emmalloc_trim;
pub const validateMemoryRegions = emmalloc_validate_memory_regions;
pub const dynamicHeapSize = emmalloc_dynamic_heap_size;
pub const freeDynamicMemory = emmalloc_free_dynamic_memory;
pub const unclaimedHeapMemory = emmalloc_unclaimed_heap_memory;
pub const computeFreeDynamicMemoryFragmentationMap = emmalloc_compute_free_dynamic_memory_fragmentation_map;

// A debug function that dumps the whole structure of malloc internal memory blocks to console.
// *extremely slow*, use for debugging allocation test cases.
extern fn emmalloc_dump_memory_regions() void;

// Allocates size bytes with the given pow-2 alignment.
extern fn emmalloc_memalign(alignment: usize, size: usize) ?[*]u8;
//pub extern fn memalign(alignment: usize, size: usize) ?*u8;
//pub extern fn aligned_alloc(alignment: usize, size: usize) ?*u8;

// Allocates size bytes with default alignment (8 bytes)
extern fn emmalloc_malloc(size: usize) ?[*]u8;
//pub extern fn malloc(size: usize) ?*u8;

// Returns the number of bytes that are actually allocated to the given pointer ptr.
// E.g. due to alignment or size requirements, the actual size of the allocation can be
// larger than what was requested.
extern fn emmalloc_usable_size(ptr: ?[*]u8) usize;
//pub extern fn malloc_usable_size(ptr: *u8) usize;

// Frees a memory pointer allocated with any of the memory allocation functions declared
// in this file, e.g.
// (emmalloc_)memalign, (emmalloc_)malloc, (emmalloc_)calloc, aligned_alloc,
// (emmalloc_)realloc, emmalloc_realloc_try, emmalloc_realloc_uninitialized, (emmalloc_)aligned_realloc
extern fn emmalloc_free(ptr: ?[*]u8) void;
//pub extern fn free(ptr: *u8) void;

// Performs a reallocation of the given memory pointer to a new size. If the memory region
// pointed by ptr cannot be resized in place, a new memory region will be allocated, old
// memory copied over, and the old memory area freed. The pointer ptr must have been
// allocated with one of the emmalloc memory allocation functions (malloc, memalign, ...).
// If called with size == 0, the pointer ptr is freed, and a null pointer is returned. If
// called with null ptr, a new pointer is allocated.
// If there is not enough memory, the old memory block is not freed and null pointer is
// returned.
extern fn emmalloc_realloc(ptr: ?[*]u8, size: usize) ?[*]u8;
//pub extern fn realloc(ptr: *u8, size: usize) ?*u8;

// emmalloc_realloc_try() is like realloc(), but only attempts to try to resize the existing
// memory area. If resizing the existing memory area fails, then realloc_try() will return 0
// (the original memory block is not freed or modified). If resizing succeeds, previous
// memory contents will be valid up to min(old length, new length) bytes.
// If a null pointer is passed, no allocation is attempted but the function will return 0.
// If zero size is passed, the function will behave like free().
extern fn emmalloc_realloc_try(ptr: ?[*]u8, size: usize) ?[*]u8;

// emmalloc_realloc_uninitialized() is like realloc(), but old memory contents
// will be undefined after reallocation. (old memory is not preserved in any case)
extern fn emmalloc_realloc_uninitialized(ptr: ?[*]u8, size: usize) ?[*]u8;

// Like realloc(), but allows specifying the alignment to allocate to. This function cannot
// be used to change the alignment of an existing allocation, but the original pointer should
// be aligned to the given alignment already.
extern fn emmalloc_aligned_realloc(ptr: [*]u8, alignment: usize, size: usize) ?[*]u8;
//pub extern fn aligned_realloc(ptr: *u8, alignment: usize, size: usize) ?*u8;

// emmalloc_aligned_realloc_uninitialized() is like aligned_realloc(), but old memory contents
// will be undefined after reallocation. (old memory is not preserved in any case)
extern fn emmalloc_aligned_realloc_uninitialized(ptr: ?[*]u8, alignment: usize, size: usize) ?[*]u8;

// posix_memalign allocates memory with a given alignment, like memalign, but with a slightly
// different usage signature.
extern fn emmalloc_posix_memalign(memptr: [*c]?*u8, alignment: usize, size: usize) c_int;
//pub extern fn posix_memalign(memptr: [*c]?*u8, alignment: usize, size: usize) c_int;

// calloc allocates memory that is initialized to zero.
extern fn emmalloc_calloc(num: usize, size: usize) ?*u8;
//pub extern fn calloc(num: c_ulonglong, size: c_ulonglong) ?*u8;

// mallinfo() returns information about current emmalloc allocation state. This function
// is very slow, only good for debugging. Avoid calling it for "routine" diagnostics.
pub const MallInfo = extern struct {
    arena: i32, // total space allocated from system
    ordblks: i32, // number of non-inuse chunks
    smblks: i32, // unused -- always zero
    hblks: i32, // number of mmapped regions
    hblkhd: i32, // total space in mmapped regions
    usmblks: i32, // unused -- always zero
    fsmblks: i32, // unused -- always zero
    uordblks: i32, // total allocated space
    fordblks: i32, // total non-inuse space
    keepcost: i32, // top-most, releasable (via malloc_trim) space
};
pub extern fn emmalloc_mallinfo(...) MallInfo;
//pub extern fn mallinfo(...) struct_mallinfo;

// malloc_trim() returns unused dynamic memory back to the WebAssembly heap. Returns 1 if it
// actually freed any memory, and 0 if not. Note: this function does not release memory back to
// the system, but it only marks memory held by emmalloc back to unused state for other users
// of sbrk() to claim.
extern fn emmalloc_trim(pad: usize) c_int;
//pub extern fn malloc_trim(pad: usize) c_int;

// Validates the consistency of the malloc heap. Returns non-zero and prints an error to console
// if memory map is corrupt. Returns 0 (and does not print anything) if memory is intact.
extern fn emmalloc_validate_memory_regions() c_int;

// Computes the size of the dynamic memory region governed by emmalloc. This represents the
// amount of memory that emmalloc has sbrk()ed in for itself to manage. Use this function
// for memory statistics tracking purposes. Calling this function is quite fast, practically
// O(1) time.
extern fn emmalloc_dynamic_heap_size() usize;

// Computes the amount of memory currently reserved under emmalloc's governance  that is free
// for the application to allocate. Use this function for memory statistics tracking purposes.
// Note that calling this function is very slow, as it walks through each free memory block in
// linear time.
extern fn emmalloc_free_dynamic_memory() usize;

// Estimates the amount of untapped memory that emmalloc could expand its dynamic memory area
// via sbrk()ing. Theoretically the maximum amount of memory that can still be malloc()ed can
// be calculated via emmalloc_free_dynamic_memory() + emmalloc_unclaimed_heap_memory().
// Calling this function is very fast constant time lookup.
extern fn emmalloc_unclaimed_heap_memory() usize;

// Computes a detailed fragmentation map of available free memory. Pass in a pointer to a
// 32 element long array. This function populates into each array index i the number of free
// memory regions that have a size 2^i <= size < 2^(i+1), and returns the total number of
// free memory regions (the sum of the array entries). This function runs very slowly, as it
// iterates through all free memory blocks.
extern fn emmalloc_compute_free_dynamic_memory_fragmentation_map(freeMemorySizeMap: [32]usize) usize;
