local trace = opts.trace and true or false
local width = math.floor(opts.width or 8)
if width < 1 then
    error 'invalid width'
end

input('!mr', trace)
input('cp', trace)
input('d', width - 1, trace)
output('q', width - 1, trace)

X7404 { 'mr', width = 1 }
wire '!mr/mr.a'

X7404 { '!d', width = width }
wire 'd/!d.a'

EdgeDetector { 'e', width = 3 }
wire 'cp/e.a'

for i = 0, width - 1 do
    local d = 'd' .. i
    SrLatch(d)
    wire(d .. '.q/q[' .. i .. ']')
    Or('s' .. d)
    wire('mr.q/s' .. d .. '.a[0]')
    wire('s' .. d .. '.q/' .. d .. '.!s')
    And('r' .. d)
    wire('!mr/r' .. d .. '.a[0]')
    wire('r' .. d .. '.q/' .. d .. '.!r')
    Nand('gs' .. d)
    wire('gs' .. d .. '.q/s' .. d .. '.a[1]')
    wire('e.q/gs' .. d .. '.a[0]')
    wire('d[' .. i .. ']/gs' .. d .. '.a[1]')
    Nand('gr' .. d)
    wire('gr' .. d .. '.q/r' .. d .. '.a[1]')
    wire('e.q/gr' .. d .. '.a[0]')
    wire('!d.q[' .. i .. ']/gr' .. d .. '.a[1]')
end
