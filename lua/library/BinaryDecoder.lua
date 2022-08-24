local width = opts.width or 4
if type(width) ~= 'number' then
    error 'invalid width type'
end
width = math.floor(width)
if width < 1 then
    error 'invalid width'
end
local outputs = math.pow(2, width)

input('a', width - 1)
output('q', outputs - 1)
X7404 { 'n', width = 1 }
wire('a[' .. (width - 1) .. ']/n.a')

if width == 1 then
    wire 'n.q/q[0]'
    wire 'a/q[1]'
else
    BinaryDecoder { 'dec', width = width - 1 }
    wire('a[0-' .. (width - 2) .. ']/dec.a')

    X7408 { 'al', width = outputs / 2 }
    X7408 { 'ah', width = outputs / 2 }

    wire('al.q/q[0-' .. (outputs / 2 - 1) .. ']')
    wire('ah.q/q[' .. (outputs / 2) .. '-' .. (outputs - 1) .. ']')

    for i = 1, outputs / 2 do
        wire('a[' .. (width - 1) .. ']/ah.a[' .. (i - 1) .. ']')
        wire('n.q/al.a[' .. (i - 1) .. ']')
        wire('dec.q[' .. (i - 1) .. ']/al.b[' .. (i - 1) .. ']')
        wire('dec.q[' .. (i - 1) .. ']/ah.b[' .. (i - 1) .. ']')
    end
end
