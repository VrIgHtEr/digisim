local trace = opts.trace and true or false
local address_width = 19
local data_width = 8

local memory = opts.memory or {}
if type(memory) ~= 'table' then
    error 'invalid memory'
end
for k, v in pairs(memory) do
    if type(k) ~= 'number' or k < 1 or k >= 524289 or k % 1 ~= 0 or type(v) ~= 'number' or v < 0 or v >= 256 then
        error 'invalid memory'
    end
end
do
    local mem = {}
    for k, v in pairs(memory) do
        mem[math.floor(k)] = math.floor(v)
    end
    memory = mem
end

input('!rst', trace)
input('!ce', trace)
input('!oe', trace)
input('!we', trace)
input('a', address_width - 1, trace)
input('d_in', data_width - 1, trace)

output('d', data_width - 1, trace)
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
        ret = bor(ret, lshift(inputs[i + 5] == high and 1 or 0, i))
    end
    return ret
end

local function read_data(inputs)
    local ret = tobit(0)
    for i = 0, data_width - 1 do
        ret = bor(ret, lshift(inputs[i + 5 + address_width] == high and 1 or 0, i))
    end
    return ret
end

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
    local reset = inputs[1]
    local ce = inputs[2]
    local oe = inputs[3]
    local we = inputs[4]

    if ce ~= low then
        for i = 1, data_width do
            outputs[i] = z
        end
        if pce == low and pwe == low then
            if reset == high then
                write(inputs)
            end
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
                if reset == high then
                    write(inputs)
                end
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
