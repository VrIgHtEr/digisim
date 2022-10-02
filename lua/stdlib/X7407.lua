local trace = opts.trace and true or false
local w = math.floor(opts.width or 6)
if w < 1 then
    error 'width < 1'
end
local d = math.floor(opts.depth or 1)
if d < 0 then
    error 'depth < 0'
end

input('a', w - 1, trace)
output('q', w - 1, trace)

if d > 0 then
    local c = 'b0'
    Buffer { c, width = w }
    wire 'a/b0.a'

    for i = 1, d - 1 do
        local n = 'b' .. i
        Buffer { n, width = w }
        wire(c .. '.q/' .. n .. '.a')
        c = n
    end

    wire(c .. '.q/q')
else
    Low 'GND'
    wire 'a/q'
end
