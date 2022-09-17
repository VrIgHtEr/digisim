const Lua = @import("lua.zig").Lua;

const std = @import("std");
const Digisim = @import("digisim.zig").Digisim;
const components = @import("./tree/component.zig").components;
const process = std.process;
const io = std.io;
const stdout = &@import("output.zig").stdout;
const buffer = &@import("output.zig").buf;

fn errmain() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);
    if (args.len < 2) return error.MissingProjectDir;

    var sim = try Digisim.init(allocator, args[1]);
    defer sim.deinit();
    try sim.runLuaSetup();
    while (true) {
        _ = try sim.step();
        if (sim.compiled.?.timestamp > 1000000) break;
    }
    return 0;
}

pub fn main() u8 {
    return errmain() catch |e| {
        _ = stdout.write("\nSIMULATOR ERROR: ") catch undefined;
        _ = stdout.write(@errorName(e)) catch undefined;
        _ = stdout.write("\n") catch undefined;
        buffer.flush() catch undefined;
        return 0;
    };
}
