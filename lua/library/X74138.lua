local w = math.floor(opts.width or 3)
if w < 1 then
    error 'invalid width'
end
local o = math.pow(2, w)

input('a', w - 1)
input '!e1'
input '!e2'
input 'e3'
output('!y', o - 1)

Not { '!!e', width = 2 }
wire '!e1/!!e.a[0]'
wire '!e2/!!e.a[1]'

Nand { 'e', width = 3 }
wire 'e3/e.a[0]'
wire '!!e.q[0]/e.a[1]'
wire '!!e.q[1]/e.a[2]'

LineDecoder { 'a', selwidth = w, active_low = true }
wire 'e.q/a.!e'
wire 'a/a.a'
wire '!y/a.!y'
wire 'e.q/a.!e'
