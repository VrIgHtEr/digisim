local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end
input('a', width - 1)
input('b', width - 1)
output('d', width - 1)
input '!oe'

High 'VCC'

X7486 { 'op', width = width }
wire 'a/op.a'
wire 'b/op.b'

X74245 { 'out', width = width }
wire '!oe/out.!oe'
wire 'VCC.q/out.dir'
wire 'op.q/out.a'
wire 'out.b/d'
