local width = math.floor(opts.width or 32)
if width < 1 then
    error 'invalid width'
end

input('a', width - 1)
input('b', width - 1)
input 'sub'
input '!oe'
output('d', width - 1)

VAluAddSub { 'add', width = width }
wire 'a/add.a'
wire 'b/add.b'
wire 'd/add.d'
wire 'sub/add.sub'
wire '!oe/add.!oe'
