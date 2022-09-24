const std = @import("std");
const Pin = @import("pin.zig").Pin;
const Digisim = @import("../digisim.zig").Digisim;
const Signal = @import("../signal.zig").Signal;
const stdout = &@import("../output.zig").stdout;

pub const Port = struct {
    pins: []Pin,
    alias: ?[]const u8,

    pub fn deinit(self: *@This(), digisim: *Digisim) void {
        digisim.allocator.free(self.pins);
        if (self.alias) |a| digisim.strings.unref(a);
    }

    pub fn trace(self: *@This()) void {
        if (self.pins.len > 1) {
            var i = self.pins.len;
            var changed = false;
            while (i > 0) {
                i -= 1;
                const net = self.pins[i].net;
                if (net.tracevalue != net.ptracevalue) {
                    changed = true;
                    break;
                }
            }
            if (!changed) return;
            stdout.print("b", .{}) catch ({});
            i = self.pins.len;
            while (i > 0) {
                i -= 1;
                const value = self.pins[i].net.tracevalue;
                if (value == Signal.z) {
                    stdout.print("z", .{}) catch ({});
                } else if (value == Signal.unknown) {
                    stdout.print("x", .{}) catch ({});
                } else if (value == Signal.low) {
                    stdout.print("0", .{}) catch ({});
                } else {
                    stdout.print("1", .{}) catch ({});
                }
            }
            stdout.print(" {s}\n", .{self.alias orelse unreachable}) catch ({});
        } else {
            const net = self.pins[0].net;
            if (net.tracevalue == net.ptracevalue) return;
            const value = Signal.tovcd(net.tracevalue);
            if (value == Signal.z) {
                stdout.print("z{s}\n", .{self.alias orelse unreachable}) catch ({});
            } else if (value == Signal.unknown) {
                stdout.print("x{s}\n", .{self.alias orelse unreachable}) catch ({});
            } else if (value == Signal.low) {
                stdout.print("0{s}\n", .{self.alias orelse unreachable}) catch ({});
            } else {
                stdout.print("1{s}\n", .{self.alias orelse unreachable}) catch ({});
            }
        }
    }
};
