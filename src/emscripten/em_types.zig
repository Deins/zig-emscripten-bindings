const CallbackFunc = *const fn () void; 
const ArgCallbackFunc = *const fn (args : [*] anyopaque) void;
const EmStrCallbackFunc = * const fn (?[*:0]const u8) void;

const EmBool = enum(u32){
    true = 1,
    false = 0,
};

const EmUtf8 = u8; // char
