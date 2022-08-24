local width = math.floor(opts.width or 32)
if width < 4 then
    error 'invalid width'
end
input '!oe'
input 'short'
input '!mr'
input 'we'
input 'count'
input 'clk'
output('d', width - 1)

Low 'GND'
High 'VCC'

X7404 { 'long', width = 1 }
wire 'short/long.a'
X74283 { 'c', width = width }
wire 'GND.q/c.cin'
wire 'GND.q/c.a[0]'
wire 'short/c.a[1]'
wire 'long.q/c.a[2]'
fan('GND.q/c.a[3-' .. (width - 1) .. ']')

X74157 { 'in', width = width }
wire 'GND.q/in.!e'
wire 'count/in.s'
wire 'd/in.a'
wire 'c.s/in.b'

X7408 { 'clk', width = 1 }
wire 'we/clk.a'
wire 'clk/clk.b'
X74273 { 'pc', width = width }
wire '!mr/pc.!mr'
wire 'clk.q/pc.cp'
wire 'in.q/pc.d'
wire 'pc.q/c.b'

X74245 { 'out', width = width }
wire '!oe/out.!oe'
wire 'VCC.q/out.dir'
wire 'pc.q/out.a'
wire 'out.b/d'
