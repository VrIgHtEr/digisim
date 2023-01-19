const Lua = @import("lua.zig").Lua;

const std = @import("std");
const Digisim = @import("digisim.zig").Digisim;
const components = @import("./tree/component.zig").components;
const process = std.process;
const io = std.io;
const stdout = &@import("output.zig").stdout;
const buffer = &@import("output.zig").buf;
const local: [:0]const u8 = ".";

fn charToDigit(c: u8) !u8 {
    if (c >= '0' and c <= '9') return c - '0';
    if (c >= 'a' and c <= 'z') return c - 'a' + 10;
    if (c >= 'A' and c <= 'Z') return c - 'A' + 10;
    return error.InvalidCharacter;
}

pub fn parseU64(buf: []const u8, radix: u8) !u64 {
    var x: u64 = 0;

    for (buf) |c| {
        const digit = try charToDigit(c);

        if (digit >= radix) {
            return error.InvalidChar;
        }

        // x *= radix
        var tresult = @mulWithOverflow(x, radix);
        if (tresult[1] != 0) {
            return error.Overflow;
        }
        x = tresult[0];

        // x += digit
        tresult = @addWithOverflow(x, digit);
        if (tresult[1] != 0) return error.Overflow;
        x = tresult[0];
    }

    return x;
}

pub fn parseI64(buf: []const u8, radix: u8) !i64 {
    return @bitCast(i64, try parseU64(buf, radix));
}

fn errmain() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var maxtick: u64 = 0;
    var stimeout: u64 = 0;
    var synchronous = true;
    var trace_all = false;

    var projdir: [:0]const u8 = local;
    var args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);
    var i: u32 = 1;
    while (i < args.len) : (i += 1) {
        const item = args[i];
        if (item.len == 0) return error.InvalidArgument;
        if (std.mem.eql(u8, item, "-f")) {
            if (!synchronous) return error.InvalidArgument;
            synchronous = false;
        } else if (std.mem.eql(u8, item, "-c")) {
            if (trace_all) return error.InvalidArgument;
            trace_all = true;
        } else if (std.mem.eql(u8, item, "-s")) {
            if (stimeout != 0) return error.InvalidArgument;
            i += 1;
            if (i == args.len) return error.InvalidArgument;
            stimeout = parseU64(args[i], 10) catch return error.InvalidArgument;
            if (stimeout == 0) return error.InvalidArgument;
        } else if (std.mem.eql(u8, item, "-t")) {
            if (maxtick != 0) return error.InvalidArgument;
            i += 1;
            if (i == args.len) return error.InvalidArgument;
            maxtick = parseU64(args[i], 10) catch return error.InvalidArgument;
            if (maxtick == std.math.maxInt(u64)) return error.InvalidArgument;
            maxtick += 1;
        } else if (projdir.ptr != local.ptr) {
            return error.InvalidArgument;
        } else {
            projdir = item;
        }
    }
    if (stimeout == 0) stimeout = 10000;

    var sim = try Digisim.init(allocator, projdir, trace_all);
    defer sim.deinit();
    try sim.runLuaSetup();
    var stable = true;
    var scounter: u64 = stimeout;
    var ticks: u64 = maxtick;
    var ret: u8 = 0;
    while (true) {
        stable = try sim.step();
        if (!synchronous or stable) try sim.trace();
        if (stable) {
            scounter = stimeout;
            if (maxtick != 0) {
                ticks -= 1;
                if (ticks == 0) break;
            }
        } else {
            scounter -= 1;
            if (scounter == 0) {
                ret = 1;
                break;
            }
        }
    }
    return ret;
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
