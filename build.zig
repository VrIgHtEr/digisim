const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    //const lj_clone = b.addSystemCommand(&[_][]const u8{ "sh", "-c", "if [ ! -d luajit ] ; then git clone https://luajit.org/git/luajit.git luajit ; fi" });
    //const lj_make = b.addSystemCommand(&[_][]const u8{ "sh", "-c", "cd luajit && make BUILDMODE=static" });
    //lj_make.step.dependOn(&lj_clone.step);

    const exe = b.addExecutable("digisim", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.linkLibC();
    exe.linkSystemLibrary("luajit");

    //exe.addIncludeDir("luajit/src");
    //exe.addObjectFile("luajit/src/libluajit.a");
    //exe.step.dependOn(&lj_make.step);

    exe.single_threaded = true;
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    b.installDirectory(.{
        .source_dir = "lua",
        .install_dir = std.build.InstallDir{ .custom = "share" },
        .install_subdir = "digisim",
    });

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("zigsim/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
