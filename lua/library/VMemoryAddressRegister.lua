local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end

High 'VCC'

output('out', width - 1)
input('d', width - 1)
input '!mr'
input 'cp'
input 'w'
input '!oe'

VRegister { 'mar', width = width }
wire 'mar.out/out'
wire 'mar.in/d'
wire 'mar.!mr/!mr'
wire 'mar.w/w'
wire 'mar.cp/cp'

X74245 { 'out', width = width }
wire 'mar.out/out.a'
wire 'VCC.q/out.dir'
wire '!oe/out.!oe'
wire 'out.b/d'
