pub const EmCallbackFunc = *const fn () void; 
pub const EmArgCallbackFunc = *const fn (args : [*] anyopaque) void;
pub const EmStrCallbackFunc = * const fn (?[*:0]const u8) void;

pub const EmBool = enum(u32){
    true = 1,
    false = 0,
};

pub const EmUtf8 = u8; // char
