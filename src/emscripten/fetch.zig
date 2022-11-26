const EmResult = u32; // TODO:  EMSCRIPTEN_RESULT 

const AttributeFlags = packed struct {
    // Emscripten fetch attributes:
    // If passed, the body of the request will be present in full in the onsuccess()
    // handler.
    load_to_memory : u1 = 0,

    // If passed, the intermediate streamed bytes will be passed in to the
    // onprogress() handler. If not specified, the onprogress() handler will still
    // be called, but without data bytes.  Note: Firefox only as it depends on
    // 'moz-chunked-arraybuffer'.
    stream_data : u1 = 0,

    // If passed, the final download will be stored in IndexedDB. If not specified,
    // the file will only reside in browser memory.
    persist_file :u1 = 0,

    // Looks up if the file already exists in IndexedDB, and if so, it is returned
    // without redownload. If a partial transfer exists in IndexedDB, the download
    // will resume from where it left off and run to completion.
    // EMSCRIPTEN_FETCH_APPEND, EMSCRIPTEN_FETCH_REPLACE and
    // EMSCRIPTEN_FETCH_NO_DOWNLOAD are mutually exclusive.  If none of these three
    // flags is specified, the fetch operation is implicitly treated as if
    // EMSCRIPTEN_FETCH_APPEND had been passed.
    append : u1 = 0,

    // If the file already exists in IndexedDB, the old file will be deleted and a
    // new download is started.
    // EMSCRIPTEN_FETCH_APPEND, EMSCRIPTEN_FETCH_REPLACE and
    // EMSCRIPTEN_FETCH_NO_DOWNLOAD are mutually exclusive.  If you would like to
    // perform an XHR that neither reads or writes to IndexedDB, pass this flag
    // EMSCRIPTEN_FETCH_REPLACE, and do not pass the flag
    // EMSCRIPTEN_FETCH_PERSIST_FILE.
    replace : u1 = 0,

    // If specified, the file will only be looked up in IndexedDB, but if it does
    // not exist, it is not attempted to be downloaded over the network but an error
    // is raised.
    // EMSCRIPTEN_FETCH_APPEND, EMSCRIPTEN_FETCH_REPLACE and
    // EMSCRIPTEN_FETCH_NO_DOWNLOAD are mutually exclusive.
    no_download : u1 = 0,

    // If specified, emscripten_fetch() will synchronously run to completion before
    // returning.  The callback handlers will be called from within
    // emscripten_fetch() while the operation is in progress.
    synchronous : u1 = 0,

    // If specified, it will be possible to call emscripten_fetch_wait() on the
    // fetch to test or wait for its completion.
    waitable : u1 = 0,

    _padding : u24 = 0,
};
comptime { if (@sizeOf(AttributeFlags) != @sizeOf(u32)) @panic("Inavlid size of AttributeFlags!"); }

// Specifies the parameters for a newly initiated fetch operation.
// emscripten_fetch_attr_t
pub const FetchAttributes = extern struct {
  pub const OnSuccess = fn (fetch : Fetch) void;
  pub const OnError = fn (fetch : Fetch) void; 
  pub const OnProgress = fn (fetch : Fetch) void; 
  pub const OnReadyStateChange = fn (fetch : Fetch) void;

  pub const Flags = AttributeFlags;

  // 'POST', 'GET', etc.
  request_method : [32]u8,

  // Custom data that can be tagged along the process.
  user_data : ?*anyopaque,

  // EMSCRIPTEN_FETCH_* attributes
  attributes : Flags,

  // Specifies the amount of time the request can take before failing due to a
  // timeout.
  timeoutMSecs : u64,

  // Indicates whether cross-site access control requests should be made using
  // credentials.
  withCredentials : EmBool,

  // Specifies the destination path in IndexedDB where to store the downloaded
  // content body. If this is empty, the transfer is not stored to IndexedDB at
  // all.  Note that this struct does not contain space to hold this string, it
  // only carries a pointer.
  // Calling emscripten_fetch() will make an internal copy of this string.
  destinationPath :  ?[*:0] const u8,

  // Specifies the authentication username to use for the request, if necessary.
  // Note that this struct does not contain space to hold this string, it only
  // carries a pointer.
  // Calling emscripten_fetch() will make an internal copy of this string.
  userName : ?[*:0] const u8,

  // Specifies the authentication username to use for the request, if necessary.
  // Note that this struct does not contain space to hold this string, it only
  // carries a pointer.
  // Calling emscripten_fetch() will make an internal copy of this string.
  password : ?[*:0] const u8 ,

  // Points to an array of strings to pass custom headers to the request. This
  // array takes the form
  // {"key1", "value1", "key2", "value2", "key3", "value3", ..., 0 }; Note
  // especially that the array needs to be terminated with a null pointer.
  requestHeaders : ?*const [*:0] const u8,

  // Pass a custom MIME type here to force the browser to treat the received
  // data with the given type.
  overriddenMimeType : ?[*:0] const u8,

  // If non-zero, specifies a pointer to the data that is to be passed as the
  // body (payload) of the request that is being performed. Leave as zero if no
  // request body needs to be sent.  The memory pointed to by this field is
  // provided by the user, and needs to be valid throughout the duration of the
  // fetch operation. If passing a non-zero pointer into this field, make sure
  // to implement *both* the onsuccess and onerror handlers to be notified when
  // the fetch finishes to know when this memory block can be freed. Do not pass
  // a pointer to memory on the stack or other temporary area here.
  requestData : [*:0] const u8,

  // Specifies the length of the buffer pointed by 'requestData'. Leave as 0 if
  // no request body needs to be sent.
  requestDataSize : usize,


  // Functions
  pub inline fn init(self : *FetchAttributes) FetchAttributes {
    var res : FetchAttributes = undefined;
    emscripten_fetch_attr_init(attr);
    return res;
  }
};

const Fetch = extern struct {
  // Unique identifier for this fetch in progress.
    id : u32,

  // Custom data that can be tagged along the process.
  userData : ?*anyopaque,

  // The remote URL that is being downloaded.
  url : [*:0] const u8,

  // In onsuccess() handler:
  //   - If the EMSCRIPTEN_FETCH_LOAD_TO_MEMORY attribute was specified for the
  //     transfer, this points to the body of the downloaded data. Otherwise
  //     this will be null.
  // In onprogress() handler:
  //   - If the EMSCRIPTEN_FETCH_STREAM_DATA attribute was specified for the
  //     transfer, this points to a partial chunk of bytes related to the
  //     transfer. Otherwise this will be null.
  // The data buffer provided here has identical lifetime with the
  // emscripten_fetch_t object itself, and is freed by calling
  // emscripten_fetch_close() on the emscripten_fetch_t pointer.
   data : [*:0] const u8,

  // Specifies the length of the above data block in bytes. When the download
  // finishes, this field will be valid even if EMSCRIPTEN_FETCH_LOAD_TO_MEMORY
  // was not specified.
   numBytes : u64,

  // If EMSCRIPTEN_FETCH_STREAM_DATA is being performed, this indicates the byte
  // offset from the start of the stream that the data block specifies. (for
  // onprogress() streaming XHR transfer, the number of bytes downloaded so far
  // before this chunk)
  dataOffset : u64,

  // Specifies the total number of bytes that the response body will be.
  // Note: This field may be zero, if the server does not report the
  // Content-Length field.
   totalBytes : u64,

  // Specifies the readyState of the XHR request:
  // 0: UNSENT: request not sent yet
  // 1: OPENED: emscripten_fetch has been called.
  // 2: HEADERS_RECEIVED: emscripten_fetch has been called, and headers and
  //    status are available.
  // 3: LOADING: download in progress.
  // 4: DONE: download finished.
  // See https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/readyState
readyState : u16,

  // Specifies the status code of the response.
   status : u16,

  // Specifies a human-readable form of the status code.
  statusText : [64]u8,

    __proxyState : u32, // WARN: TODO: _Atomic flag 

  // For internal use only.
   __attributes : FetchAttributes,


   pub const init = emscripten_fetch;
   pub const wait = emscripten_fetch_wait;
   pub const close = emscripten_fetch_close;
   pub const getResponseHeadersLength = emscripten_fetch_get_response_headers_length;
    pub const getResponseHeaders = emscripten_fetch_get_response_headers;
    pub const unpackResponseHeaders = emscripten_fetch_unpack_response_headers;
    pub const freeUnpackedResponseHeaders = emscripten_fetch_free_unpacked_response_headers;
};

// Clears the fields of an emscripten_fetch_attr_t structure to their default
// values in a future-compatible manner.
extern fn emscripten_fetch_attr_init(*FetchAttributes) void;

// Initiates a new Emscripten fetch operation, which downloads data from the
// given URL or from IndexedDB database.
extern fn emscripten_fetch(*FetchAttributes, url : [*:0] const u8) ?*Fetch;

// Synchronously blocks to wait for the given fetch operation to complete. This
// operation is not allowed in the main browser thread, in which case it will
// return EMSCRIPTEN_RESULT_NOT_SUPPORTED. Pass timeoutMSecs=infinite to wait
// indefinitely. If the wait times out, the return value will be
// EMSCRIPTEN_RESULT_TIMED_OUT.
// The onsuccess()/onerror()/onprogress() handlers will be called in the calling
// thread from within this function before this function returns.
extern fn emscripten_fetch_wait(*Fetch, timeout_msecs : f64) EmResult;

// Closes a finished or an executing fetch operation and frees up all memory. If
// the fetch operation was still executing, the onerror() handler will be called
// in the calling thread before this function returns.
extern fn emscripten_fetch_close(*Fetch) EmResult;

// Gets the size (in bytes) of the response headers as plain text.
// This must be called on the same thread as the fetch originated on.
// Note that this will return 0 if readyState < HEADERS_RECEIVED.
extern fn emscripten_fetch_get_response_headers_length(*Fetch) usize;

// Gets the response headers as plain text. dstSizeBytes should be
// headers_length + 1 (for the null terminator).
// This must be called on the same thread as the fetch originated on.
extern fn emscripten_fetch_get_response_headers(*Fetch, dst : [*:0] u8, dstSizeBytes : usize) usize;

// Converts the plain text headers into an array of strings. This array takes
// the form {"key1", "value1", "key2", "value2", "key3", "value3", ..., 0 };
// Note especially that the array is terminated with a null pointer.
extern fn emscripten_fetch_unpack_response_headers( headers_string : [*:0] const u8) ?*const[*:0] const u8;

// This frees the memory used by the array of headers. Call this when finished
// with the data returned by emscripten_fetch_unpack_response_headers.
extern fn  emscripten_fetch_free_unpacked_response_headers(unpacked_headers : *const [:0] const u8) void;
