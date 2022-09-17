local w = math.floor(opts.width or 4)
if w < 1 then
    error 'width < 1'
end

input('a', w - 1)
input('b', w - 1)
input 'cin'
output 'c'
output('s', w - 1)

local prev = 'cin'
for i = 0, w - 1 do
    local fa = 'a' .. i
    FullAdder(fa)
    wire(fa .. '.a/a[' .. i .. ']')
    wire(fa .. '.b/b[' .. i .. ']')
    wire(fa .. '.s/s[' .. i .. ']')
    wire(fa .. '.cin/' .. prev)
    prev = fa .. '.c'
    if i == w - 1 then
        wire(fa .. '.c/c')
    end
end
