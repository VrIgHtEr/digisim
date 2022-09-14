local width = math.floor(opts.width or 32)
if width < 4 then
    error 'invalid width'
end

input('rs1', 4)
input('rs2', 4)
input('rd', 4)
input '!mr'
input 'clk'
input('d', width - 1)
output('a', width - 1)
output('b', width - 1)

VLineDecoder5x32 'rs1'
wire 'GND/rs1.!e'
wire 'rs1/rs1.a'

VLineDecoder5x32 'rs2'
wire 'GND/rs2.!e'
wire 'rs2/rs2.a'

VLineDecoder5x32 '!rd'
wire 'GND/!rd.!e'
wire 'rd/!rd.a'
X7404 { 'rd', width = 32 }
wire '!rd.y/rd.a'

for i = 1, 31 do
    local x = 'x' .. i
    VGpRegister { x, width = width }
    wire(x .. '.clk/clk')
    wire(x .. '.!mr/!mr')
    wire(x .. '.d/d')
    wire(x .. '.a/a')
    wire(x .. '.b/b')
    wire(x .. '.we/rd.q[' .. i .. ']')
    wire(x .. '.!oea/rs1.y[' .. i .. ']')
    wire(x .. '.!oeb/rs2.y[' .. i .. ']')
end
