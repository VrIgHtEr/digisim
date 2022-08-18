local z = sig.z
local low = sig.low
local high = sig.high

local w = opts.width or 1
if w < 1 then
    error 'invalid width'
end
local sequence = opts.sequence or {}
if type(sequence) ~= 'table' then
    error 'invalid sequence'
end
for _, x in ipairs(sequence) do
    if type(x) ~= 'table' or #x < 1 then
        error 'invalid sequence'
    end
    for i, y in ipairs(x) do
        if type(y) ~= 'number' or y < 0 or y > 7 then
            error 'invalid sequence'
        end
    end
end
input 'clk'
output('q', w - 1)
local max_step = #sequence
local step = 1
local pclk = low
cheat(function(inputs, outputs)
    if inputs[1] == low then
        if pclk == high then
            if step <= max_step then
                step = step + 1
            end
        end
        pclk = low
    else
        pclk = high
    end
    if step > max_step then
        for i = 1, w do
            outputs[i] = z
        end
        return 0
    else
        local s = sequence[step]
        for i = 1, w do
            outputs[i] = s[i] or z
        end
        return 0
    end
end)
