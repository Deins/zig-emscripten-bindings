# WIP: emscripten API bindings for zig  

This repository contains zigified version of: https://github.com/emscripten-core/emscripten/tree/main/system/include  
As well as some utilites for integration with zig std library, such as allocator wrapper etc.
Most emscripten headers can be @cImported without issues, however zig bindings  purpose is to allow nicer integration as well as providing better type-safety.

## Header status  `src/emscripten/*`:

| header            | rewritten  | tested | notes                    |
|-------------------|:----------:|:------:|----------------------------|
|atomic.h           | ❌    | ❌ |                                  |
|bind.h             | ❌    | ❌ |                                  |
|console.h          | ☑️    | ⚠️ | basic log functions are ok. variadic logf untested: could have issues due to removed `__attribute__((__format__(printf, 1, 2)))` |
|dom_pk_codes.h     | ❌    | ❌ |                                  |
|emmalloc.h         | ☑️    | ☑️ |                                  |
|em_asm.h           | ❌    | ❌ |                                  |
|em_js.h            | ❌    | ❌ |                                  |
|em_macros.h        | ❌    | ❌ |                                  |
|em_math.h          | ❌    | ❌ |                                  |
|em_types.h         | ☑️    | ❌ |                                  |
|eventloop.h        | ☑️    | ❌ |                                  |
|exports.h          | ❌    | ❌ |                                  |
|fetch.h            | 🛠️    | ❌ |                                  |
|fiber.h            | ❌    | ❌ |                                  |
|heap.h             | ☑️    | ❌ |                                  |
|html5.h            | ❌    | ❌ |                                  |
|html5_webgl.h      | ❌    | ❌ |                                  |
|html5_webgpu.h     | ❌    | ❌ |                                  |
|key_codes.h        | ❌    | ❌ |                                  |
|posix_socket.h     | ❌    | ❌ |                                  |
|proxying.h         | ❌    | ❌ |                                  |
|stack.h            | ❌    | ❌ |                                  |
|threading.h        | ❌    | ❌ |                                  |
|trace.h            | ❌    | ❌ |                                  |
|val.h              | ❌    | ❌ |                                  |
|version.h          | ❌    | ❌ |                                  |
|wasmfs.h           | ❌    | ❌ |                                  |
|wasm_worker        | ❌    | ❌ |                                  |
|websocket.h        | ❌    | ❌ |                                  |
|wget.h             | ❌    | ❌ |                                  |
|wire.h             | ❌    | ❌ |                                  |

# Zig specific bindings

* Allocators (file `src/allocator.zig`):
    * ☑️ BuiltinAllocator **(doesn't have realloc)**
    * ☑️ EmMalloc allocator

## Usage

Add package to your project in `build.zig`;

```zig
    const emscripten_pkg = std.build.Pkg{
        .name = "emscripten",
        .source = .{ .path = sdkPath("path to emscripten.zig")},
        .dependencies = &.{},
    };
    ...
    my_lib_or_exe.addPackage(emscripten_pkg);
```

Usage:

```zig
const ems = @import("emscripten");

ems.console.log("hello world");

var gpa : ems.allocator.EmmalocAllocator = .{};
var allocator : std.mem.Allocator = gpa.allocator();
```
