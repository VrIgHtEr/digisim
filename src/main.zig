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
        if (@mulWithOverflow(u64, x, radix, &x)) {
            return error.Overflow;
        }

        // x += digit
        if (@addWithOverflow(u64, x, digit, &x)) {
            return error.Overflow;
        }
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

    var maxtick: i64 = -1;

    var projdir: [:0]const u8 = local;
    var args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);
    var i: u32 = 1;
    while (i < args.len) : (i += 1) {
        const item = args[i];
        if (item.len == 0) return error.InvalidArgument;
        if (std.mem.eql(u8, item, "-t")) {
            if (maxtick >= 0) return error.InvalidArgument;
            i += 1;
            if (i == args.len) return error.InvalidArgument;
            const arg = parseU64(args[i], 10) catch return error.InvalidArgument;
            if (arg > std.math.maxInt(i64)) return error.InvalidArgument;
            maxtick = @bitCast(i64, arg);
        } else if (projdir.ptr != local.ptr) {
            return error.InvalidArgument;
        } else {
            projdir = item;
        }
    }

    var sim = try Digisim.init(allocator, projdir);
    defer sim.deinit();
    try sim.runLuaSetup();
    while (true) {
        _ = try sim.step();
        if (maxtick >= 0 and sim.compiled.?.timestamp > maxtick) break;
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
