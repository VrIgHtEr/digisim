local width = math.floor(opts.width or 32)
if width < 4 then
    error 'invalid width'
end

input('d', width - 1)
input '!oea'
input '!oeb'
input 'clk'
input 'we'
input '!mr'
input('rs1', 4)
input('rs2', 4)
input('rd', 4)
output('a', width - 1)
output('b', width - 1)

High 'VCC'
Low 'GND'
