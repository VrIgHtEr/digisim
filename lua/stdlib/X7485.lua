local trace = opts.trace and true or false
local width = math.floor(opts.width or 4)
if width < 1 then
    error 'invalid width'
end

input('a', width - 1, trace)
input('b', width - 1, trace)
input('lt_in', trace)
input('eq_in', trace)
input('gt_in', trace)

output('gt', trace)
output('eq', trace)
output('lt', trace)

local a = 'a[' .. (width - 1) .. ']'
local b = 'b[' .. (width - 1) .. ']'
X7404 { 'n', width = 2 }
wire(a .. '/n.a[0]')
wire(b .. '/n.a[1]')

Xnor 'eq'
wire(a .. '/eq.a[0]')
wire(b .. '/eq.a[1]')

And 'lt'
wire 'n.q[0]/lt.a[0]'
wire(b .. '/lt.a[1]')

And 'gt'
wire(a .. '/gt.a[0]')
wire 'n.q[1]/gt.a[1]'

local lt_in, eq_in, gt_in
if width == 1 then
    lt_in, eq_in, gt_in = 'lt_in', 'eq_in', 'gt_in'
else
    X7485 { 'x', width = width - 1 }
    wire 'lt_in/x.lt_in'
    wire 'eq_in/x.eq_in'
    wire 'gt_in/x.gt_in'
    wire('a[0-' .. (width - 2) .. ']/x.a')
    wire('b[0-' .. (width - 2) .. ']/x.b')
    lt_in, eq_in, gt_in = 'x.lt', 'x.eq', 'x.gt'
end

And 'eq_out'
wire 'eq.q/eq_out.a[0]'
wire(eq_in .. '/eq_out.a[1]')
wire 'eq_out.q/eq'

And 'sublt'
wire 'eq.q/sublt.a[0]'
wire(lt_in .. '/sublt.a[1]')
Or 'lt_out'
wire 'lt.q/lt_out.a[0]'
wire 'sublt.q/lt_out.a[1]'
wire 'lt_out.q/lt'

And 'subgt'
wire 'eq.q/subgt.a[0]'
wire(gt_in .. '/subgt.a[1]')
Or 'gt_out'
wire 'gt.q/gt_out.a[0]'
wire 'subgt.q/gt_out.a[1]'
wire 'gt_out.q/gt'
