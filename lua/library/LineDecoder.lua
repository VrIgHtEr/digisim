local selwidth = math.floor(opts.selwidth or 1)
if selwidth < 1 or selwidth > 20 then
    error 'invalid selwidth'
end
local active_low = opts.active_low and true or false
local enable_pins = math.floor(opts.enable_pins or 1)
if enable_pins < 1 then
    error 'invalid enable_pins'
end
local width = math.pow(2, selwidth)
input('a', selwidth - 1)
output('y', width - 1);
(active_low and X7404 or X7408) { 'na', width = selwidth }
wire 'a/na.a'

X7400 { 'out', width = 16 }
wire 'out.q/y'
if enable_pins == 1 then
    if active_low then
        input '!e'
        X7400 { 'e', width = 1 }
        wire '!e/e.a'
        fan 'e.q/out.a'
    else
        input 'e'
        fan 'e/out.a'
    end
else
    And { 'e', width = enable_pins }
    if active_low then
        X7404 { 'ne', width = enable_pins }
        for i = 0, enable_pins - 1 do
            local x = '!e' .. i
            input(x)
            wire(x .. '/ne.a[' .. i .. ']')
        end
        wire 'ne.q/e.a'
    else
        for i = 0, enable_pins - 1 do
            local x = 'e' .. i
            input(x)
            wire(x .. '/e.a[' .. i .. ']')
        end
    end
    fan 'e.q/out.a'
end

for i = 0, width - 1 do
    local y = 'y' .. i
    And { y, width = selwidth }
    wire(y .. '.q/out.b[' .. i .. ']')
    for j = 0, selwidth - 1 do
        local input
        if bit.band(bit.rshift(i, j), 1) == 0 then
            input = 'na.q'
        else
            input = 'a'
        end
        wire(input .. '[' .. j .. ']/' .. y .. '.a[' .. j .. ']')
    end
end
