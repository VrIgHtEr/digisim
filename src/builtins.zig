const Signal = @import("signal.zig").Signal;
const std = @import("std");
const Lua = @import("lua.zig");
const LuaState = Lua.State;
const Digisim = @import("digisim.zig").Digisim;

pub const LuaHandlerState = packed struct {
    d: *Digisim,
    input: c_int,
    output: c_int,
    handler: c_int,
    state_handle: c_int,

    pub fn create(d: *Digisim, handler: c_int) !*@This() {
        var ud: *anyopaque align(8) = d.lua.newuserdata(@sizeOf(LuaHandlerState)) orelse return error.OutOfMemory;
        const ret = @ptrCast(*LuaHandlerState, @alignCast(@alignOf(*LuaHandlerState), ud));
        ret.d = d;
        ret.state_handle = d.lua.ref();
        ret.handler = handler;
        d.lua.newtable();
        ret.input = d.lua.ref();
        d.lua.newtable();
        ret.output = d.lua.ref();
        return ret;
    }

    pub fn deinit(self: *@This()) void {
        self.d.lua.unref(self.input);
        self.d.lua.unref(self.output);
        self.d.lua.unref(self.handler);
        self.d.lua.unref(self.state_handle);
    }
};

pub fn lua_h(input: []Signal, output: []Signal, data: *usize) usize {
    const s = @intToPtr(*LuaHandlerState, data.*);
    _ = s.d.lua.checkstack(4);
    s.d.lua.loadref(s.handler);
    s.d.lua.loadref(s.input);
    for (input, 0..) |sig, idx| {
        s.d.lua.pushnumber(@intToFloat(f64, @enumToInt(sig)));
        s.d.lua.rawseti(-2, @intCast(c_int, idx + 1));
    }
    s.d.lua.loadref(s.output);
    if (s.d.lua.pcall(2, 1, 0) != 0) {
        s.d.lua.err("error running component lua handler");
    }
    if (!s.d.lua.isnumber(-1)) {
        s.d.lua.err("function `f' must return a number");
    }
    const retf = s.d.lua.tonumber(-1);
    s.d.lua.pop(1);
    if (retf < 0) s.d.lua.err("invalid lua handler return value");
    const ret = @floatToInt(usize, retf);
    s.d.lua.loadref(s.output);
    for (output, 0..) |*sig, idx| {
        _ = s.d.lua.rawgeti(-1, @intCast(c_int, idx + 1));
        if (!s.d.lua.isnumber(-1)) {
            sig.* = Signal.unknown;
        } else {
            const vf = s.d.lua.tonumber(-1);
            if (vf < 0 or vf > 7) {
                sig.* = Signal.unknown;
            } else {
                sig.* = @intToEnum(Signal, @floatToInt(u8, vf));
            }
        }
        s.d.lua.pop(1);
    }
    s.d.lua.pop(1);
    return ret;
}

pub fn nand_h(input: []Signal, output: []Signal, _: *usize) usize {
    for (input) |x| {
        if (x != Signal.high) {
            output[0] = Signal.high;
            return 0;
        }
    }
    output[0] = Signal.low;
    return 0;
}

pub fn and_h(input: []Signal, output: []Signal, _: *usize) usize {
    for (input) |x| {
        if (x != Signal.high) {
            output[0] = Signal.low;
            return 0;
        }
    }
    output[0] = Signal.high;
    return 0;
}

pub fn or_h(input: []Signal, output: []Signal, _: *usize) usize {
    for (input) |x| {
        if (x == Signal.high) {
            output[0] = Signal.high;
            return 0;
        }
    }
    output[0] = Signal.low;
    return 0;
}

pub fn nor_h(input: []Signal, output: []Signal, _: *usize) usize {
    for (input) |x| {
        if (x == Signal.high) {
            output[0] = Signal.low;
            return 0;
        }
    }
    output[0] = Signal.high;
    return 0;
}

pub fn not_h(input: []Signal, output: []Signal, _: *usize) usize {
    for (input, 0..) |x, idx| {
        if (x == Signal.high) {
            output[idx] = Signal.low;
        } else output[idx] = Signal.high;
    }
    return 0;
}

pub fn xor_h(input: []Signal, output: []Signal, _: *usize) usize {
    var ret = false;
    for (input) |x| {
        if (x == Signal.high)
            ret = !ret;
    }
    if (ret) {
        output[0] = Signal.high;
    } else output[0] = Signal.low;
    return 0;
}

pub fn xnor_h(input: []Signal, output: []Signal, _: *usize) usize {
    var ret = false;
    for (input) |x| {
        if (x == Signal.high)
            ret = !ret;
    }
    if (ret) {
        output[0] = Signal.low;
    } else output[0] = Signal.high;
    return 0;
}

pub fn global_reset_h(_: []Signal, output: []Signal, data: *usize) usize {
    if (data.* != 0) {
        const ret = data.*;
        data.* = 0;
        output[0] = Signal.low;
        return ret;
    } else output[0] = Signal.high;
    return 0;
}

pub fn clock_h(_: []Signal, output: []Signal, data: *usize) usize {
    const mask: usize = (std.math.maxInt(usize) >> 1) + 1;
    const period = data.* & ~mask;
    if ((data.* & mask) != 0) {
        output[0] = Signal.high;
        data.* = period;
    } else {
        output[0] = Signal.low;
        data.* |= mask;
    }
    return period;
}

pub fn pullup_h(_: []Signal, output: []Signal, _: *usize) usize {
    for (output, 0..) |_, idx| output[idx] = Signal.weakhigh;
    return 0;
}

pub fn pulldown_h(_: []Signal, output: []Signal, _: *usize) usize {
    for (output, 0..) |_, idx| output[idx] = Signal.weaklow;
    return 0;
}

pub fn high_h(_: []Signal, output: []Signal, _: *usize) usize {
    for (output, 0..) |_, idx| output[idx] = Signal.high;
    return 0;
}

pub fn low_h(_: []Signal, output: []Signal, _: *usize) usize {
    for (output, 0..) |_, idx| output[idx] = Signal.low;
    return 0;
}

pub fn buffer_h(input: []Signal, output: []Signal, _: *usize) usize {
    for (input, 0..) |x, idx| {
        output[idx] = x;
    }
    return 0;
}

pub fn tristate_buffer_h(input: []Signal, output: []Signal, _: *usize) usize {
    var i: usize = 1;
    if (input[0] == Signal.high) {
        while (i < input.len) : (i += 1) {
            output[i - 1] = input[i];
        }
    } else {
        while (i < input.len) : (i += 1) {
            output[i - 1] = Signal.z;
        }
    }
    return 0;
}
