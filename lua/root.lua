local l, z, h = sig.low, sig.z, sig.high

VControlBus { 'ctrl', trace = true }
VDataBus { 'data', trace = true }

VStartModule { 'start' }
wire 'ctrl.!rst/start.!rst'
wire 'ctrl.clk/start.clk'

VMemoryInterface 'mem'
wire 'ctrl.clk/mem.clk'
wire 'mem.!word/ctrl.!mem_word'
wire 'mem.!half/ctrl.!mem_half'
wire 'mem.!ce/ctrl.!mem_ce'
wire 'mem.!oe/ctrl.!mem_oe'
wire 'mem.!w/ctrl.!mem_we'
wire 'mem.signed/ctrl.mem_signed'
wire 'mem.a/data.address'
wire 'mem.d/data.d'

VRegister 'mar'
wire 'mar.out/data.address'
wire 'mar.in/data.d'
wire 'ctrl.clk/mar.cp'
wire 'ctrl.!rst/mar.!mr'
wire 'ctrl.mar_in/mar.w'

VRegister 'ir'
wire 'ir.out/data.instruction'
wire 'ir.in/data.d'
wire 'ctrl.clk/ir.cp'
wire 'ctrl.!rst/ir.!mr'
wire 'ctrl.ir_in/ir.w'

VProgramCounter { 'pc', width = 32 }
wire 'ctrl.!rst/pc.!mr'
wire 'ctrl.!pc_oe/pc.!oe'
wire 'ctrl.pc_short/pc.short'
wire 'ctrl.pc_count/pc.count'
wire 'ctrl.pc_we/pc.we'
wire 'ctrl.clk/pc.clk'

VAlu 'alu'
wire 'data.a/alu.a'
wire 'data.b/alu.b'
wire 'data.d/alu.d'
wire 'ctrl.!alu_oe/alu.!oe'
wire 'ctrl.alu_sub/alu.sub'
wire 'ctrl.alu_op/alu.op'
wire 'ctrl.alu_signed/alu.signed'
wire 'alu.lt/ctrl.alu_lt'
wire 'alu.eq/ctrl.alu_eq'
wire 'alu.gt/ctrl.alu_gt'

VRegisterBank 'registers'
wire 'data.d/registers.d'
wire 'data.a/registers.a'
wire 'data.b/registers.b'
wire 'ctrl.clk/registers.clk'
wire 'ctrl.!rst/registers.!mr'
wire 'ctrl.rs1/registers.rs1'
wire 'ctrl.rs2/registers.rs2'
wire 'ctrl.rd/registers.rd'

local function outputnumber(seq, num)
    if num == nil then
        for _ = 1, 32 do
            seq[#seq + 1] = z
        end
    else
        num = math.floor(num)
        for _ = 1, 32 do
            seq[#seq + 1] = (num % 2) == 0 and l or h
            num = math.floor(num * 0.5)
        end
    end
end

local function row(ce, we, oe, half, word, signed, mar_in, ir_in, alu_oe, alu_sub, data)
    local ret = { ce or z, we or z, oe or z, half or z, word or z, signed or z, mar_in or z, ir_in or z, alu_oe or z, alu_sub or z }
    outputnumber(ret, data)
    return ret
end

local function addWrite(seq, half, word, signed, address, data)
    seq[#seq + 1] = row(z, z, z, z, z, z, h, l, h, l, address)
    seq[#seq + 1] = row(l, l, h, half, word, signed, l, l, h, l, data)
end

local function addRead(seq, half, word, signed, address)
    seq[#seq + 1] = row(z, z, z, z, z, z, h, l, h, l, address)
    seq[#seq + 1] = row(l, h, l, half, word, signed, l, h, h, l)
end

local function generate()
    local seq = { row() }
    for i = 0, 15 do
        addWrite(seq, h, h, h, i, i)
    end
    for i = 0, 15 do
        addWrite(seq, h, h, h, i + 16, i + 255 - 15)
    end
    for i = 0, 31 do
        addRead(seq, h, h, h, i)
    end
    for i = 0, 31 do
        addRead(seq, l, h, h, i)
    end
    for i = 0, 31 do
        addRead(seq, l, l, h, i)
    end
    for i = 0, 31 do
        addRead(seq, h, h, l, i)
    end
    for i = 0, 31 do
        addRead(seq, l, h, l, i)
    end
    for i = 0, 31 do
        addRead(seq, l, l, l, i)
    end
    addWrite(seq, l, h, h, 0, 0xABCD)
    addRead(seq, l, h, h, 0)
    addRead(seq, l, h, l, 0)
    addWrite(seq, l, h, h, 3, 0xABCD)
    addRead(seq, l, h, h, 3)
    addRead(seq, l, h, l, 3)

    addWrite(seq, l, l, h, 0, 0xdeadbeef)
    addRead(seq, l, l, h, 0)
    addWrite(seq, l, l, h, 5, 0xdeadbeef)
    addRead(seq, l, l, h, 5)
    addWrite(seq, l, l, h, 10, 0xdeadbeef)
    addRead(seq, l, l, h, 10)
    addWrite(seq, l, l, h, 15, 0xdeadbeef)
    addRead(seq, l, l, h, 15)

    for i = 0, 31 do
        addRead(seq, h, h, h, i)
        addRead(seq, h, h, l, i)
    end
    return seq
end

Sequencer {
    'test',
    width = 10 + 32,
    sequence = generate(),
}
wire 'ctrl.clk/test.clk'
wire 'test.q[0]/ctrl.!mem_ce'
wire 'test.q[1]/ctrl.!mem_we'
wire 'test.q[2]/ctrl.!mem_oe'
wire 'test.q[3]/ctrl.!mem_half'
wire 'test.q[4]/ctrl.!mem_word'
wire 'test.q[5]/ctrl.mem_signed'
wire 'test.q[6]/ctrl.mar_in'
wire 'test.q[7]/ctrl.ir_in'
wire 'test.q[8]/ctrl.!alu_oe'
wire 'test.q[9]/ctrl.alu_sub'
wire 'test.q[10-41]/data.d'
