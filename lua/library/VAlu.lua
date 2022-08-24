local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end
local shwidth = math.log(width, 2)
if shwidth % 1 ~= 0 then
    error 'width must be a power of 2'
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

X7404 { '!eb', width = 1 }
wire 'op[2]/!eb.a'
X74139 'sel'
wire 'op[0-1]/sel.sa'
wire 'op[0-1]/sel.sb'
wire 'op[2]/sel.!ea'
wire '!eb.q/sel.!eb'

X7404 { 'left', width = 1 }
wire 'sel.!qa[1]/left.a'
VBarrelShifter { 'shift', shwidth = shwidth }
wire('b[0-' .. (shwidth - 1) .. ']/shift.shamt')
wire 'sub/shift.arithmetic'
wire 'a/shift.d'
wire 'left.q/shift.left'

And 'signed'
wire 'signed/signed.a[0]'
wire 'sel.!qa[3]/signed.a[1]'

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
wire 'ha.a[0]/signed.q'
wire('ha.a[1]/a[' .. (width - 1) .. ']')
wire('ha.q/comp.a[' .. (width - 1) .. ']')
Xor 'hb'
wire 'hb.a[0]/signed.q'
wire('hb.a[1]/b[' .. (width - 1) .. ']')
wire('hb.q/comp.b[' .. (width - 1) .. ']')

VAluAddSub { 'add', width = width }
wire 'a/add.a'
wire 'b/add.b'
wire 'out.a/add.d'
wire 'sub/add.sub'
wire 'sel.!qa[0]/add.!oe'

Xnor 'sll_rx'
wire 'sel.!qa[1]/sll_rx.a[0]'
wire 'sel.!qb[1]/sll_rx.a[1]'
X74245 { 'sh', width = width }
wire 'VCC.q/sh.dir'
wire 'sll_rx.q/sh.!oe'
wire 'shift.q/sh.a'
wire 'sh.b/out.a'

Xnor 'slt_u'
wire 'sel.!qa[2]/slt_u.a[0]'
wire 'sel.!qa[3]/slt_u.a[1]'
X74245 { 'slt', width = 32 }
wire 'VCC.q/slt.dir'
wire 'slt_u.q/slt.!oe'
fan('GND.q/slt.a[1-' .. (width - 1) .. ']')
wire 'slt.b/out.a'

VAluXor { 'xor', width = width }
wire 'a/xor.a'
wire 'b/xor.b'
wire 'out.a/xor.d'
wire 'sel.!qb[0]/xor.!oe'

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
