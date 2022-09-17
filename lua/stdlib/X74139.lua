local w = math.floor(opts.width or 2)
if w < 1 then
    error 'invalid width'
end
local o = math.pow(2, w)

input('sa', w - 1)
input('sb', w - 1)
input '!ea'
input '!eb'
output('!qa', o - 1)
output('!qb', o - 1)

LineDecoder { 'a', selwidth = w, active_low = true }
wire '!ea/a.!e'
wire 'sa/a.a'
wire '!qa/a.!y'

LineDecoder { 'b', selwidth = w, active_low = true }
wire '!eb/b.!e'
wire 'sb/b.a'
wire '!qb/b.!y'
