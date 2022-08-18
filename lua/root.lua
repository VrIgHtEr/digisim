local l = sig.low
local z = sig.z
local h = sig.high

Reset { 'rst', period = 100 }
Clock { 'clk', period = 1000 }

VControlBus { 'ctrl', trace = true }
VDataBus { 'data', trace = true }

VMemoryInterface 'mem'
wire 'mem.!word/ctrl.!mem_word'
wire 'mem.!half/ctrl.!mem_half'
wire 'mem.!ce/ctrl.!mem_ce'
wire 'mem.!oe/ctrl.!mem_oe'
wire 'mem.!w/ctrl.!mem_we'
wire 'mem.signed/ctrl.mem_signed'
wire 'mem.a/data.address'
wire 'mem.d/data.d'

Sequencer {
    'test',
    width = 14 + 32 + 24,
    sequence = {
        { h, h, h, h, h, l, z, z, z, z, z, z, z, z },
        { h, h, l, h, h, l, z, z, z, z, z, z, z, z },
        { h, h, h, h, h, l, z, z, z, z, z, z, z, z },
        { h, h, l, h, h, l, z, z, z, z, z, z, z, z },
        { h, l, l, h, h, l, z, z, z, z, z, z, z, z },
        { h, l, h, h, h, l, z, z, z, z, z, z, z, z },
        { l, h, h, h, h, l, z, z, z, z, z, z, z, z },
        { l, h, l, h, h, l, z, z, z, z, z, z, z, z },
        { l, h, h, h, h, l, z, z, z, z, z, z, z, z },
        { l, h, l, h, h, l, z, z, z, z, z, z, z, z },
        { l, l, l, h, h, l, z, z, z, z, z, z, z, z },
        { l, l, h, h, h, l, h, h, h, h, h, h, h, h },
        { h, h, h, h, h, l, h, h, h, h, h, h, h, h },
        { l, h, l, h, h, l, z, z, z, z, z, z, z, z },
        { h, h, h, h, h, l, z, z, z, z, z, z, z, z },
    },
}
wire 'clk.q/test.clk'
wire 'test.q[0]/ctrl.!mem_ce'
wire 'test.q[1]/ctrl.!mem_we'
wire 'test.q[2]/ctrl.!mem_oe'
wire 'test.q[3]/ctrl.!mem_half'
wire 'test.q[4]/ctrl.!mem_word'
wire 'test.q[5]/ctrl.mem_signed'
wire 'test.q[6-37]/data.d'
wire 'test.q[38-69]/data.address'
