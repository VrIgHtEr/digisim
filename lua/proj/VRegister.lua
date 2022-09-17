local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end

input('in', width - 1)
input 'w'
input 'cp'
input '!mr'
output('out', width - 1)

X74273 { 'r', width = width }
wire '!mr/r.!mr'
wire 'in/r.d'
wire 'out/r.q'

And 'clk'
wire 'cp/clk.a[0]'
wire 'w/clk.a[1]'
wire 'clk.q/r.cp'
