const std = @import("std");
const stdout = &@import("output.zig").stdout;
const c = @cImport({
    // See https://github.com/ziglang/zig/issues/515
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cDefine("NULL", "(0)");
    @cInclude("lua.h");
    @cInclude("lauxlib.h");
    @cInclude("lualib.h");
});

pub const State = *c.lua_State;
const LuaFunc = *const fn (?State) callconv(.C) c_int;
const Digisim = @import("digisim.zig").Digisim;
const Component = @import("tree/component.zig").Component;
const Components = @import("builtins.zig");
pub const Error = error{ CannotInitialize, LoadStringFailed, ScriptError, OutputClosed };
pub const Lua = struct {
    digisim: *Digisim,
    L: State,

    fn upvalueindex(x: c_int) c_int {
        return c.LUA_GLOBALSINDEX - x;
    }

    fn getInstance(L: ?State) *Digisim {
        const v = c.lua_touserdata(L orelse unreachable, upvalueindex(1));
        return @intToPtr(*Digisim, @ptrToInt(v));
    }

    fn lua_version(L: ?State) callconv(.C) c_int {
        getInstance(L).lua.pushlstring("0.1.0");
        return 1;
    }

    fn getcomponent(digisim: *Digisim, comp: ?*anyopaque) !*Component {
        if (comp) |cmp| {
            return digisim.components.getPtr(@ptrToInt(cmp)) orelse return error.ComponentNotFound;
        } else return &digisim.root;
    }

    fn lua_createcomponent(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 2) lua.err("invalid number of arguments passed to createcomponent");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument to createcomponent was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument to createcomponent was not a string");
        const str = lua.tolstring(1 - args);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createport(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 6) lua.err("invalid number of arguments passed to createport");

        if (!lua.islightuserdata(0 - args)) lua.err("1st arg not a userdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("2nd arg not a string");
        const name = lua.tolstring(1 - args);

        if (!lua.isboolean(2 - args)) lua.err("3rd arg not a boolean");
        const input = lua.toboolean(2 - args);

        if (!lua.isnumber(3 - args)) lua.err("4th arg not a number");
        const start = @floatToInt(usize, lua.tonumber(3 - args));

        if (!lua.isnumber(4 - args)) lua.err("5th arg not a number");
        const end = @floatToInt(usize, lua.tonumber(4 - args));

        if (!lua.isboolean(5 - args)) lua.err("6th arg not a boolean");
        const trace = lua.toboolean(5 - args);

        _ = comp.addPort(name, input, start, end, trace) catch lua.err("failed to add port");
        return 0;
    }

    fn lua_connect(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to connect");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument to connect was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument to connect was not a string");
        const stra = lua.tolstring(1 - args);

        if (!lua.isstring(2 - args)) lua.err("third argument to connect was not a string");
        const strb = lua.tolstring(2 - args);

        comp.connect(stra, strb) catch lua.err("failed to connect ports");
        return 0;
    }

    fn lua_fan(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to fan");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument to fan was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument to fan was not a string");
        const stra = lua.tolstring(1 - args);

        if (!lua.isstring(2 - args)) lua.err("third argument to fan was not a string");
        const strb = lua.tolstring(2 - args);

        comp.fan(stra, strb) catch lua.err("failed to connect ports");
        return 0;
    }

    fn lua_createreset(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("third argument was not a number");
        const periodf = lua.tonumber(2 - args);

        if (periodf < 1 or periodf >= 16777216) lua.err("reset period out of range");
        const period = @floatToInt(usize, periodf);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.data = period;
        cmp.setHandler(Components.global_reset_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createclock(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("third argument was not a number");
        const periodf = lua.tonumber(2 - args);

        if (periodf < 1 or periodf >= 16777216) lua.err("reset period out of range");
        const period = @floatToInt(usize, periodf);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("q", false, 0, 0, true) catch lua.err("failed to add port q");
        cmp.data = period;
        cmp.setHandler(Components.clock_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createhigh(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 2) lua.err("invalid number of arguments");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.high_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createlow(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 2) lua.err("invalid number of arguments");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.low_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createnand(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 1 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.nand_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createand(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 1 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.and_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createor(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 1 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.or_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createnor(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 1 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.nor_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createxor(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 1 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.xor_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createxnor(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 1 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, 0, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.xnor_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createnot(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnot");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 0 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, pin_end, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.not_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createpulldown(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 0 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("q", false, 0, pin_end, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.pulldown_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createpullup(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 0 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("q", false, 0, pin_end, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.pullup_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createbuffer(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 0 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, pin_end, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.buffer_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_createtristatebuffer(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 3) lua.err("invalid number of arguments passed to createnand");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isstring(1 - args)) lua.err("second argument was not a string");
        const str = lua.tolstring(1 - args);

        if (!lua.isnumber(2 - args)) lua.err("3rd arg not a number");
        const pin_end_f = lua.tonumber(2 - args);
        if (pin_end_f < 0 or pin_end_f >= 1048576) lua.err("pin_end out of range");
        const pin_end = @floatToInt(usize, pin_end_f);

        const id = comp.addComponent(str) catch lua.err("failed to create component");
        const cmp = digisim.components.getPtr(id) orelse unreachable;

        _ = cmp.addPort("en", true, 0, 0, false) catch lua.err("failed to add port en");
        _ = cmp.addPort("a", true, 0, pin_end, false) catch lua.err("failed to add port a");
        _ = cmp.addPort("q", false, 0, pin_end, false) catch lua.err("failed to add port q");
        cmp.setHandler(Components.tristate_buffer_h) catch unreachable;
        lua.pushlightuserdata(@intToPtr(*anyopaque, id));
        return 1;
    }

    fn lua_attachhandler(L: ?State) callconv(.C) c_int {
        const digisim = getInstance(L);
        const lua = &digisim.lua;
        const args = lua.gettop();
        if (args < 2) lua.err("invalid number of arguments passed");

        if (!lua.islightuserdata(0 - args)) lua.err("first argument was not a lightuserdata");
        const comp = getcomponent(digisim, lua.touserdata(0 - args)) catch lua.err("component not found");

        if (!lua.isfunction(1 - args)) lua.err("second argument was not a function");
        lua.settop(1 - args);

        const rf = lua.ref();
        const state = Components.LuaHandlerState.create(digisim, rf) catch ({
            lua.unref(rf);
            lua.err("Failed to initialize lua handler state");
        });
        comp.data = @ptrToInt(state);
        comp.setHandler(Components.lua_h) catch ({
            comp.data = 0;
            state.deinit();
            lua.err("Failed to set handler");
        });

        return 0;
    }

    pub fn init(digisim: *Digisim) Error!Lua {
        var self: @This() = undefined;
        self.digisim = digisim;
        self.L = c.luaL_newstate() orelse return Error.CannotInitialize;
        errdefer c.lua_close(self.L);
        c.luaL_openlibs(self.L);
        self.newtable();

        self.pushlstring("version");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_version, 1);
        self.settable(-3);

        self.pushlstring("createcomponent");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createcomponent, 1);
        self.settable(-3);

        self.pushlstring("createport");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createport, 1);
        self.settable(-3);

        self.pushlstring("connect");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_connect, 1);
        self.settable(-3);

        self.pushlstring("fan");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_fan, 1);
        self.settable(-3);

        self.pushlstring("cheat");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_attachhandler, 1);
        self.settable(-3);

        self.pushlstring("root");
        self.pushlightuserdata(null);
        self.settable(-3);

        self.pushlstring("components");
        self.newtable();
        self.pushlstring("Nand");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createnand, 1);
        self.settable(-3);
        self.pushlstring("And");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createand, 1);
        self.settable(-3);
        self.pushlstring("Or");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createor, 1);
        self.settable(-3);
        self.pushlstring("Nor");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createnor, 1);
        self.settable(-3);
        self.pushlstring("Xor");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createxor, 1);
        self.settable(-3);
        self.pushlstring("Xnor");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createxnor, 1);
        self.settable(-3);
        self.pushlstring("Not");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createnot, 1);
        self.settable(-3);
        self.pushlstring("Pullup");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createpullup, 1);
        self.settable(-3);
        self.pushlstring("Pulldown");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createpulldown, 1);
        self.settable(-3);
        self.pushlstring("Reset");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createreset, 1);
        self.settable(-3);
        self.pushlstring("High");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createhigh, 1);
        self.settable(-3);
        self.pushlstring("Low");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createlow, 1);
        self.settable(-3);
        self.pushlstring("Buffer");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createbuffer, 1);
        self.settable(-3);
        self.pushlstring("TristateBuffer");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createtristatebuffer, 1);
        self.settable(-3);
        self.pushlstring("Clock");
        self.pushlightuserdata(digisim);
        self.pushcclosure(lua_createclock, 1);
        self.settable(-3);
        self.settable(-3);

        self.setglobal("digisim");
        return self;
    }

    pub fn err(self: *@This(), message: []const u8) noreturn {
        self.pushlstring(message);
        _ = c.lua_error(self.L);
        unreachable;
    }

    pub fn gettop(self: *@This()) c_int {
        return c.lua_gettop(self.L);
    }

    pub fn settable(self: *@This(), index: c_int) void {
        c.lua_settable(self.L, index);
    }

    pub fn pushlightuserdata(self: *@This(), p: ?*anyopaque) void {
        c.lua_pushlightuserdata(self.L, p);
    }

    pub fn newtable(self: *@This()) void {
        c.lua_newtable(self.L);
    }

    pub fn pushcclosure(self: *@This(), func: LuaFunc, vals: c_int) void {
        c.lua_pushcclosure(self.L, func, vals);
    }

    pub fn pushnumber(self: *@This(), num: f64) void {
        c.lua_pushnumber(self.L, num);
    }

    pub fn pushcfunction(self: *@This(), func: LuaFunc) void {
        c.lua_pushcfunction(self.L, func);
    }

    pub fn deinit(self: *@This()) void {
        c.lua_close(self.L);
    }

    pub fn loadstring(self: *@This(), string: [:0]const u8) Error!void {
        var status = c.luaL_loadstring(self.L, string.ptr);
        if (status != 0) {
            stdout.print("Couldn't load string: {s}", .{c.lua_tostring(self.L, -1)}) catch return Error.OutputClosed;
            c.lua_pop(self.L, -1);
            return Error.LoadStringFailed;
        }
    }

    pub fn execute(self: *@This(), script: [:0]const u8) Error!void {
        try self.loadstring(script);

        var result = c.lua_pcall(self.L, 0, c.LUA_MULTRET, 0);
        if (result != 0) {
            stdout.print("Failed to run script: {s}", .{c.lua_tostring(self.L, -1)}) catch return Error.OutputClosed;
            c.lua_pop(self.L, -1);
            return Error.ScriptError;
        }
        c.lua_pop(self.L, -1);
    }

    pub fn pushnil(self: *@This()) void {
        c.lua_pushnil(self.L);
    }

    pub fn setglobal(self: *@This(), glob: [:0]const u8) void {
        c.lua_setglobal(self.L, @ptrCast([*c]const u8, glob));
    }

    pub fn getglobal(self: *@This(), glob: [:0]const u8) void {
        c.lua_getglobal(self.L, @ptrCast([*c]const u8, glob));
    }

    pub fn pushstring(self: *@This(), glob: [:0]const u8) void {
        c.lua_pushstring(self.L, @ptrCast([*c]const u8, glob));
    }

    pub fn pushlstring(self: *@This(), glob: []const u8) void {
        c.lua_pushlstring(self.L, @ptrCast([*c]const u8, glob.ptr), glob.len);
    }

    pub fn gettable(self: *@This(), pos: c_int) void {
        c.lua_gettable(self.L, pos);
    }

    pub fn islightuserdata(self: *@This(), pos: c_int) bool {
        return c.lua_islightuserdata(self.L, pos);
    }

    pub fn toboolean(self: *@This(), pos: c_int) bool {
        return c.lua_toboolean(self.L, pos) != 0;
    }

    pub fn isboolean(self: *@This(), pos: c_int) bool {
        return c.lua_isboolean(self.L, pos);
    }

    pub fn isnumber(self: *@This(), pos: c_int) bool {
        return c.lua_isnumber(self.L, pos) != 0;
    }

    pub fn isstring(self: *@This(), pos: c_int) bool {
        return c.lua_isstring(self.L, pos) != 0;
    }

    pub fn isfunction(self: *@This(), pos: c_int) bool {
        return c.lua_isfunction(self.L, pos);
    }

    pub fn pop(self: *@This(), pos: c_int) void {
        c.lua_pop(self.L, pos);
    }

    pub fn tonumber(self: *@This(), pos: c_int) f64 {
        return c.lua_tonumber(self.L, pos);
    }

    pub fn touserdata(self: *@This(), pos: c_int) ?*anyopaque {
        return c.lua_touserdata(self.L, pos);
    }

    pub fn tolstring(self: *@This(), pos: c_int) []const u8 {
        var len: usize = 0;
        const str = c.lua_tolstring(self.L, pos, &len);
        return str[0..len];
    }

    pub fn rawset(self: *@This(), pos: c_int) void {
        c.lua_rawset(self.L, pos);
    }

    pub fn rawgeti(self: *@This(), index: c_int, n: c_int) void {
        c.lua_rawgeti(self.L, index, n);
    }

    pub fn rawseti(self: *@This(), index: c_int, n: c_int) void {
        c.lua_rawseti(self.L, index, n);
    }

    pub fn ref(self: *@This()) c_int {
        return c.luaL_ref(self.L, c.LUA_REGISTRYINDEX);
    }

    pub fn loadref(self: *@This(), r: c_int) void {
        self.rawgeti(c.LUA_REGISTRYINDEX, r);
    }

    pub fn unref(self: *@This(), r: c_int) void {
        c.luaL_unref(self.L, c.LUA_REGISTRYINDEX, r);
    }

    pub fn settop(self: *@This(), r: c_int) void {
        c.lua_settop(self.L, r);
    }

    pub fn pcall(self: *@This(), nargs: c_int, nresults: c_int, errfunc: c_int) c_int {
        return c.lua_pcall(self.L, nargs, nresults, errfunc);
    }

    pub fn newuserdata(self: *@This(), size: usize) ?*anyopaque {
        return c.lua_newuserdata(self.L, size);
    }

    pub fn checkstack(self: *@This(), size: c_int) c_int {
        return c.lua_checkstack(self.L, size);
    }

    fn prependLuaPath(self: *@This(), prefix: []const u8) !void {
        self.getglobal("package");
        self.pushstring("path");
        self.gettable(-2);
        if (self.isstring(-1)) {
            const path = self.tolstring(-1);
            const concatenated = try std.mem.concat(std.heap.c_allocator, u8, &[_][]const u8{ prefix, ";", path });
            defer std.heap.c_allocator.free(concatenated);
            self.pop(1);
            self.pushstring("path");
            self.pushlstring(concatenated);
            self.rawset(-3);
            self.pop(1);
        } else {
            self.pop(2);
        }
    }
    pub fn setupenv(self: *@This(), root: [:0]const u8, projroot: [:0]const u8) !void {
        {
            var str = try std.fs.path.join(std.heap.c_allocator, &[_][]const u8{ root[0..root.len], "?/init.lua" });
            defer std.heap.c_allocator.free(str);
            try self.prependLuaPath(str);
        }
        {
            var str = try std.fs.path.join(std.heap.c_allocator, &[_][]const u8{ root[0..root.len], "?.lua" });
            defer std.heap.c_allocator.free(str);
            try self.prependLuaPath(str);
        }
        self.pushlstring(root);
        self.setglobal("digisim_path");
        self.pushlstring(projroot);
        self.setglobal("project_path");
    }
};
