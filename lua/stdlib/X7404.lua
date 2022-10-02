local trace = opts.trace and true or false
local w = math.floor(opts.width or 6)
if w < 1 then
    error 'invalid width'
end
input('a', w - 1, trace)
output('q', w - 1, trace)
Not { 'n', width = w }
wire 'a/n.a'
wire 'q/n.q'
