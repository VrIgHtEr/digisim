local address_width = 19
local data_width = 8

input '!ce'
input '!oe'
input '!we'
input('a', address_width - 1)
input('d_in', data_width - 1)

output('d', data_width - 1)
wire 'd/d_in'

local high = sig.high
local low = sig.low
local z = sig.z

local pce = high
local pwe = high
local bor = bit.bor
local tobit = bit.tobit
local lshift = bit.lshift
local band = bit.band

local function read_address(inputs)
    local ret = tobit(0)
    for i = 0, address_width - 1 do
        ret = bor(ret, lshift(inputs[i + 4] == high and 1 or 0, i))
    end
    return ret
end

local function read_data(inputs)
    local ret = tobit(0)
    for i = 0, data_width - 1 do
        ret = bor(ret, lshift(inputs[i + 4 + address_width] == high and 1 or 0, i))
    end
    return ret
end

local memory = {}
local function write(inputs)
    local address = read_address(inputs)
    local data = read_data(inputs)
    memory[address + 1] = data
end

local function read_byte(address)
    return memory[address + 1] or tobit(0)
end

local function read(inputs, outputs)
    local data = read_byte(read_address(inputs))
    for i = 0, data_width - 1 do
        if band(data, lshift(1, i)) == 0 then
            outputs[i + 1] = low
        else
            outputs[i + 1] = high
        end
    end
end

cheat(function(inputs, outputs)
    local ce = inputs[1]
    local oe = inputs[2]
    local we = inputs[3]

    if ce ~= low then
        for i = 1, data_width do
            outputs[i] = z
        end
        if pce == low and pwe == low then
            write(inputs)
        end
        pce, pwe = high, high
    else
        if we == low then
            for i = 1, data_width do
                outputs[i] = z
            end
            pwe = low
        else
            if pwe == low then
                write(inputs)
            end
            if oe == high then
                for i = 1, data_width do
                    outputs[i] = z
                end
            else
                read(inputs, outputs)
            end
            pwe = high
        end
        pce = low
    end

    return 0
end)
