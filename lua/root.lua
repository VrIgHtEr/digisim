local l = sig.low
local z = sig.z
local h = sig.high

Reset { 'rst', period = 100 }
Clock { 'clk', period = 1000 }

VControlBus { 'ctrl', trace = true }
VDataBus { 'data', trace = true }

VMemoryInterface 'mem'
wire 'clk.q/mem.clk'
wire 'mem.!word/ctrl.!mem_word'
wire 'mem.!half/ctrl.!mem_half'
wire 'mem.!ce/ctrl.!mem_ce'
wire 'mem.!oe/ctrl.!mem_oe'
wire 'mem.!w/ctrl.!mem_we'
wire 'mem.signed/ctrl.mem_signed'
wire 'mem.a/data.address'
wire 'mem.d/data.d'

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

local function row(ce, we, oe, half, word, signed, data, address)
    local ret = { ce or z, we or z, oe or z, half or z, word or z, signed or z }
    outputnumber(ret, data)
    outputnumber(ret, address)
    return ret
end

local function addWrite(seq, half, word, signed, address, data)
    seq[#seq + 1] = row(l, l, h, half, word, signed, data, address)
    --seq[#seq + 1] = row(h, h, h, half, word, signed, data, address)
end

local function addRead(seq, half, word, signed, address)
    seq[#seq + 1] = row(l, h, l, half, word, signed, nil, address)
end

local function generate()
    local seq = { row(h, h, h, h, h, h) }
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
    width = 14 + 32 + 24,
    sequence = generate() or {
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
