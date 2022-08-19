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

local c = 'b0'
Buffer { c, width = w }
--
--for i = 1, w - 1 do
--    local n = 'b' .. i
--    Buffer { n, width = w }
--    wire(c .. '.q/' .. n .. '.a')
--    c = n
--end
--
wire 'c.q/q'
