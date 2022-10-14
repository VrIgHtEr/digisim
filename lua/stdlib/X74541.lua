local trace = opts.trace and true or false
local w = math.floor(opts.width or 8)
if w < 1 then
    error 'width < 1'
end

input('a', w - 1, trace)
output('b', w - 1, trace)
input('!oe1', trace)
input('!oe2', trace)

X7402 { 'oe', width = 1 }
wire '!oe1/oe.a'
wire '!oe2/oe.b'

TristateBufferBank { 'buf', width = w }
wire 'a/buf.a'
wire 'oe.q/buf.en'
wire 'buf.q/b'
