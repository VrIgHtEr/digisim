local trace = opts.trace and true or false
local w = math.floor(opts.width or 2)
if w < 1 then
    error 'invalid width'
end
local o = math.pow(2, w)

input('sa', w - 1, trace)
input('sb', w - 1, trace)
input('!ea', trace)
input('!eb', trace)
output('!qa', o - 1, trace)
output('!qb', o - 1, trace)

LineDecoder { 'a', selwidth = w, active_low = true }
wire '!ea/a.!e'
wire 'sa/a.a'
wire '!qa/a.!y'

LineDecoder { 'b', selwidth = w, active_low = true }
wire '!eb/b.!e'
wire 'sb/b.a'
wire '!qb/b.!y'
