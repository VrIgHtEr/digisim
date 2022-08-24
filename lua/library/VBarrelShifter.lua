local shwidth = math.floor(opts.shwidth or 1)
if shwidth < 1 then
    error 'invalid shwidth'
end
local width = math.pow(2, shwidth)

High 'VCC'
Low 'GND'

input('shamt', shwidth - 1)
input 'arithmetic'
input 'left'
input('d', width - 1)
output('q', width - 1)

X74157 { 'in', width = width }
wire 'GND.q/in.!e'
wire 'left/in.s'
wire 'd/in.a'
for i = 0, width - 1 do
    wire('in.b[' .. i .. ']/d[' .. (width - 1 - i) .. ']')
end

local res = 'in.q'
for i = 0, shwidth - 1 do
    local shamt = math.pow(2, i)
    local x = 'shift' .. i
    X74157 { x, width = width }
    wire(x .. '.!e/GND.q')
    wire(x .. '.s/shamt[' .. i .. ']')
    wire(x .. '.a/' .. res)

    local s = 's' .. i
    And(s)
    wire('arithmetic/' .. s .. '.a[0]')
    wire(res .. '[' .. (width - 1 - shamt) .. ']/' .. s .. '.a[1]')

    for j = 0, shamt - 1 do
        wire(x .. '.b[' .. (width - 1 - j) .. ']/' .. s .. '.q')
    end
    for j = shamt, width - 1 do
        wire(x .. '.b[' .. (width - 1 - j) .. ']/' .. res .. '[' .. (width - 1 - j + shamt) .. ']')
    end
    res = x .. '.q'
end

X74157 { 'out', width = width }
wire 'GND.q/out.!e'
wire 'left/out.s'
wire 'out.q/q'
wire(res .. '/out.a')
for i = 0, width - 1 do
    wire('out.b[' .. i .. ']/' .. res .. '[' .. (width - 1 - i) .. ']')
end
