local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end
input('a', width - 1)
input('b', width - 1)
output('d', width - 1)
input 'sub'
input '!oe'

High 'VCC'

XorBank { '!b', width = width }
wire 'b/!b.a'
fan 'sub/!b.b'

X74283 { 'adder', width = width }
wire 'a/adder.a'
wire '!b.q/adder.b'
wire 'sub/adder.cin'

X74245 { 'out', width = width }
wire '!oe/out.!oe'
wire 'VCC.q/out.dir'
wire 'adder.s/out.a'
wire 'out.b/d'
