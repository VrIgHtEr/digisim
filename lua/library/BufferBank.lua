local w = math.floor(opts.width or 1)
if w < 1 then
    error 'width < 1'
end
local d = math.floor(opts.depth or 1)
if d < 1 then
    error 'depth < 1'
end

input('a', w - 1)
output('q', w - 1)

for i = 0, w - 1 do
    local prev = 'x' .. i .. '_0'
    Buffer(prev)
    wire('a[' .. i .. ']/prev.a')
    for j = 1, d - 1 do
        local n = 'x' .. i .. '_' .. j
        Buffer(n)
        wire(prev .. '.q/' .. n .. '.a')
        prev = n
    end
    wire(prev .. '.q/q[' .. i .. ']')
end
