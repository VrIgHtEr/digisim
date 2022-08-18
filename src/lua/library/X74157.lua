local w = math.floor(opts.width or 4)
if w < 1 then
    error 'width < 1'
end

input '!e'
input 's'
input('a', w - 1)
input('b', w - 1)
output('q', w - 1)

Not 'ns'
wire 's/ns.a'

Nor 's1'
wire 'ns.q/s1.a[0]'
wire '!e/s1.a[1]'

Nor 's0'
wire 's/s0.a[0]'
wire '!e/s0.a[1]'

for i = 0, w - 1 do
    local a1 = 'a1' .. i
    And(a1)
    wire('s1.q/' .. a1 .. '.a[0]')
    wire('b[' .. i .. ']/' .. a1 .. '.a[1]')
    local a0 = 'a0' .. i
    And(a0)
    wire('s0.q/' .. a0 .. '.a[0]')
    wire('a[' .. i .. ']/' .. a0 .. '.a[1]')
    local o = 'o' .. i
    Or(o)
    wire(a1 .. '.q/' .. o .. '.a[0]')
    wire(a0 .. '.q/' .. o .. '.a[1]')
    wire(o .. '.q/q[' .. i .. ']')
end
