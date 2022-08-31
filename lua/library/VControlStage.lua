local width = math.floor(opts.width or 0)
if width < 0 then
    error 'invalid width'
end
input 'in'
input 'pause'
output 'out'
output 'clk'
output '!mr'

X74273 { 'm', width = 1 }
wire '!mr/m.!mr'
wire 'clk/m.cp'

X7404 { '!pause', width = 1 }
wire 'pause/!pause.a'

X7408 { 'out', width = 1 }
wire '!pause.q/out.a'
wire 'm.q/out.b'
wire 'out.q/out'

X7432 { 'in', width = 1 }
wire 'in/in.a'
wire 'm.d/in.q'

X7408 { 'p', width = 1 }
wire 'm.q/p.a'
wire 'pause/p.b'
wire 'p.q/in.b'

if width > 0 then
    input('din', width - 1)
    output('dout', width - 1)

    X7404 { '!out', width = 1 }
    wire 'out.q/!out.a'
    High 'VCC'
    X74245 { 'data', width = width }
    wire '!out.q/data.!oe'
    wire 'VCC.q/data.dir'
    wire 'din/data.a'
    wire 'dout/data.b'
end
