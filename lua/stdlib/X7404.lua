local w = math.floor(opts.width or 6)
if w < 1 then
    error 'invalid width'
end
input('a', w - 1)
output('q', w - 1)
Not { 'n', width = w }
wire 'a/n.a'
wire 'q/n.q'
