local width = math.floor(opts.width or 1)
if width < 1 then
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
