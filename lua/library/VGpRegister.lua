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
output('a', width - 1)
output('b', width - 1)

X7408 { 'we', width = 1 }
wire 'clk/we.a'
wire 'we/we.b'

X74273 { 'r', width = width }
wire '!mr/r.!mr'
wire 'd/r.d'
wire 'we.q/r.cp'

X74245 { 'oa', width = width }
wire 'oa.dir/VCC'
wire '!oea/oa.!oe'
wire 'oa.b/a'
wire 'r.q/oa.a'

X74245 { 'ob', width = width }
wire 'ob.dir/VCC'
wire '!oeb/ob.!oe'
wire 'ob.b/b'
wire 'r.q/ob.a'
