local width = math.floor(opts.width or 0)
if width < 0 then
    error 'invalid width'
end
input 'in'
output 'out'
output 'clk'
output '!mr'

X74273 { 'm', width = 1 }
wire '!mr/m.!mr'
wire 'clk/m.cp'
wire 'out/m.q'
wire 'm.d/in'

if width > 0 then
    input('din', width - 1)
    output('dout', width - 1)

    X7404 { '!out', width = 1 }
    wire 'out/!out.a'

    X74245 { 'data', width = width }
    wire '!out.q/data.!oe'
    wire 'VCC/data.dir'
    wire 'din/data.a'
    wire 'dout/data.b'
end
