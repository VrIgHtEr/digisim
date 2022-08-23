local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end

input('a', width - 1)
input('b', width - 1)
input 'sub'
input '!oe'
input 'signed'
input('op', 2)
output('d', width - 1)
output 'lt'
output 'eq'
output 'gt'

Low 'GND'
High 'VCC'

X74245 { 'out', width = width }
wire 'VCC.q/out.dir'
wire '!oe/out.!oe'
wire 'out.b/d'

X7485 { 'comp', width = width }
wire 'GND.q/comp.lt_in'
wire 'GND.q/comp.gt_in'
wire 'VCC.q/comp.eq_in'
wire 'comp.lt/lt'
wire 'comp.eq/eq'
wire 'comp.gt/gt'
wire('a[0-' .. (width - 2) .. ']/comp.a[0-' .. (width - 2) .. ']')
wire('b[0-' .. (width - 2) .. ']/comp.b[0-' .. (width - 2) .. ']')
Xor 'ha'
wire 'ha.a[0]/signed'
wire('ha.a[1]/a[' .. (width - 1) .. ']')
wire('ha.q/comp.a[' .. (width - 1) .. ']')
Xor 'hb'
wire 'hb.a[0]/signed'
wire('hb.a[1]/b[' .. (width - 1) .. ']')
wire('hb.q/comp.b[' .. (width - 1) .. ']')

Not '!eb'
wire 'op[2]/!eb.a'
X74139 'sel'
wire 'op[0-1]/sel.sa'
wire 'op[0-1]/sel.sb'
wire 'op[2]/sel.!ea'
wire '!eb.q/sel.!eb'

VAluAddSub { 'add', width = width }
wire 'a/add.a'
wire 'b/add.b'
wire 'out.a/add.d'
wire 'sub/add.sub'
wire 'sel.!qa[0]/add.!oe'

--SLL
--SLT
--SLTU

VAluXor { 'xor', width = width }
wire 'a/xor.a'
wire 'b/xor.b'
wire 'out.a/xor.d'
wire 'sel.!qb[0]/xor.!oe'

--SRx

VAluOr { 'or', width = width }
wire 'a/or.a'
wire 'b/or.b'
wire 'out.a/or.d'
wire 'sel.!qb[2]/or.!oe'

VAluAnd { 'and', width = width }
wire 'a/and.a'
wire 'b/and.b'
wire 'out.a/and.d'
wire 'sel.!qb[3]/and.!oe'
