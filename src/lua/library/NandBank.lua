local w = math.floor(opts.width or 1)
if w < 1 then
    error 'width < 1'
end

input('a', w - 1)
input('b', w - 1)
output('q', w - 1)

for i = 0, w - 1 do
    Nand('x' .. i)
    wire('x' .. i .. '.a[0]/a[' .. i .. ']')
    wire('x' .. i .. '.a[1]/b[' .. i .. ']')
    wire('x' .. i .. '.q/q[' .. i .. ']')
end
