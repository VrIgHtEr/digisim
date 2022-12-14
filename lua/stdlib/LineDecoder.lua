local trace = opts.trace and true or false
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
input('a', selwidth - 1, trace)
output(active_low and '!y' or 'y', width - 1, trace);
(active_low and X7404 or X7408) { 'na', width = selwidth }
wire 'a/na.a'
X7400 { 'out', width = width }
wire('out.q/' .. (active_low and '!' or '') .. 'y')
if enable_pins == 1 then
    if active_low then
        input('!e', trace)
        X7404 { 'e', width = 1 }
        wire '!e/e.a'
        fan 'e.q/out.a'
    else
        input('e', trace)
        fan 'e/out.a'
    end
else
    And { 'e', width = enable_pins }
    fan 'e.q/out.a'
    if active_low then
        X7404 { 'ne', width = enable_pins }
        for i = 0, enable_pins - 1 do
            local x = '!e' .. i
            input(x, trace)
            wire(x .. '/ne.a[' .. i .. ']')
        end
        wire 'ne.q/e.a'
    else
        for i = 0, enable_pins - 1 do
            local x = 'e' .. i
            input(x, trace)
            wire(x .. '/e.a[' .. i .. ']')
        end
    end
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
