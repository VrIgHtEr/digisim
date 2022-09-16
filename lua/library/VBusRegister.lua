local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end

input('d', width - 1)
input 'w'
input 'cp'
input '!mr'
input '!oe'

X74273 { 'r', width = width }
wire '!mr/r.!mr'
wire 'd/r.d'

And 'clk'
wire 'cp/clk.a[0]'
wire 'w/clk.a[1]'
wire 'clk.q/r.cp'

X74245 { 'out', width = width }
wire 'r.q/out.a'
wire 'VCC/out.dir'
wire '!oe/out.!oe'
wire 'd/out.b'
