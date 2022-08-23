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

VAluAnd { 'and', width = width }
wire 'a/and.a'
wire 'b/and.b'
wire 'd/and.d'
wire '!oe/and.!oe'

VAluOr { 'or', width = width }
wire 'a/or.a'
wire 'b/or.b'
wire 'd/or.d'
wire '!oe/or.!oe'

VAluXor { 'xor', width = width }
wire 'a/xor.a'
wire 'b/xor.b'
wire 'd/xor.d'
wire '!oe/xor.!oe'
