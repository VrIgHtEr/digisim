local w = math.floor(opts.width or 4)
if w < 1 then
    error 'width < 1'
end

input('a', w - 1)
input('b', w - 1)
output('q', w - 1)

NandBank { 'bank', width = w }
wire 'a/bank.a'
wire 'b/bank.b'
wire 'q/bank.q'
