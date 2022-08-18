Reset { 'rst', period = 100 }
Clock { 'clk', period = 1000 }

VControlBus 'ctrl'
VDataBus 'data'

VMemoryInterface 'mem'
wire 'mem.!word/ctrl.!mem_word'
wire 'mem.!half/ctrl.!mem_half'
wire 'mem.!ce/ctrl.!mem_ce'
wire 'mem.!oe/ctrl.!mem_oe'
wire 'mem.!w/ctrl.!mem_we'
wire 'mem.signed/ctrl.mem_signed'
wire 'mem.a/data.d'

Sram 'ram'
wire 'data.d[0-18]/ram.a'
wire 'ram.!oe/ctrl.!mem_oe'
wire 'ram.!ce/ctrl.!mem_ce'
wire 'ram.!we/ctrl.!mem_we'

output('data', 7, true)
wire 'ram.d/data'
output('address', 18, true)
wire 'ram.a/address'

local l = sig.low
local z = sig.z
local h = sig.high
Sequencer {
    'test',
    width = 11,
    sequence = {
        { h, h, h, z, z, z, z, z, z, z, z },
        { h, h, l, z, z, z, z, z, z, z, z },
        { h, h, h, z, z, z, z, z, z, z, z },
        { h, h, l, z, z, z, z, z, z, z, z },
        { h, l, l, z, z, z, z, z, z, z, z },
        { h, l, h, z, z, z, z, z, z, z, z },
        { l, h, h, z, z, z, z, z, z, z, z },
        { l, h, l, z, z, z, z, z, z, z, z },
        { l, h, h, z, z, z, z, z, z, z, z },
        { l, h, l, z, z, z, z, z, z, z, z },
        { l, l, l, z, z, z, z, z, z, z, z },
        { l, l, h, h, h, h, h, h, h, h, h },
        { h, h, h, h, h, h, h, h, h, h, h },
        { l, h, l, z, z, z, z, z, z, z, z },
        { h, h, h, z, z, z, z, z, z, z, z },
    },
}
wire 'clk.q/test.clk'
wire 'test.q[0]/ctrl.!mem_ce'
wire 'test.q[1]/ctrl.!mem_we'
wire 'test.q[2]/ctrl.!mem_oe'
wire 'test.q[3-10]/ram.d'
