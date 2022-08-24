input '!e0'
input '!e1'
input('a', 3)
output('y', 15)

X7404 { 'ne', width = 2 }
wire '!e0/ne.a[0]'
wire '!e1/ne.a[1]'
X7408 { 'e', width = 1 }
wire 'ne.q[0]/e.a'
wire 'ne.q[1]/e.b'

X7404 { 'na', width = 4 }
wire 'a/na.a'

X7400 { 'out', width = 16 }
wire 'out.q/output'
fan 'e.q/out.a'

for i = 0, 15 do
    local y = 'y' .. i
    And { y, width = 4 }
    wire(y .. '.q/out.b[' .. i .. ']')
    for j = 0, 3 do
        local input
        if bit.band(bit.rshift(i, j), 1) == 0 then
            input = 'na.q'
        else
            input = 'a'
        end
        wire(input .. '[' .. j .. ']/' .. y .. '.a[' .. j .. ']')
    end
end
