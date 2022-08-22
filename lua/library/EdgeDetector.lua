local w = math.floor(opts.width or 1)
if w < 1 or w % 2 == 0 then
    error 'invalid width'
end

local falling = opts.falling and true or false

input 'a'
output 'q'

local prev = 'n0'
Not(prev)
wire('a/' .. prev .. '.a')
for i = 1, w - 1 do
    local n = 'n' .. i
    Not(n)
    wire(prev .. '.q/' .. n .. '.a')
    prev = n
end

local e = 'e'
if falling then
    Nor(e)
else
    And(e)
end
wire 'a/e.a[0]'
wire(prev .. '.q/e.a[1]')
wire 'e.q/q'
