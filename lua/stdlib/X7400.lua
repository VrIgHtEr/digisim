local trace = opts.trace and true or false
local w = math.floor(opts.width or 4)
if w < 1 then
    error 'width < 1'
end

input('a', w - 1, trace)
input('b', w - 1, trace)
output('q', w - 1, trace)

for i = 0, w - 1 do
    Nand('x' .. i)
    wire('x' .. i .. '.a[0]/a[' .. i .. ']')
    wire('x' .. i .. '.a[1]/b[' .. i .. ']')
    wire('x' .. i .. '.q/q[' .. i .. ']')
end
