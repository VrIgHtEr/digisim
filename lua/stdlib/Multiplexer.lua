local width = math.floor(opts.width or 1)
if width < 1 then
    error 'invalid mux width'
end
local datawidth = math.pow(2, width)

input('sel', width - 1)
input('d', datawidth - 1)
output 'q'

Not 'ns'
wire('sel[' .. (width - 1) .. ']/ns.a')

And 's0'
wire 'ns.q/s0.a[0]'
And 's1'
wire('sel[' .. (width - 1) .. ']/s1.a[0]')

if width == 1 then
    wire 'd[0]/s0.a[1]'
    wire 'd[1]/s1.a[1]'
else
    Multiplexer { 'm0', width = width - 1 }
    wire('sel[0-' .. (width - 2) .. ']/m0.sel')
    wire('d[0-' .. (datawidth / 2 - 1) .. ']/m0.d')
    wire 'm0.q/s0.a[1]'

    Multiplexer { 'm1', width = width - 1 }
    wire('sel[0-' .. (width - 2) .. ']/m1.sel')
    wire('d[' .. (datawidth / 2) .. '-' .. (datawidth - 1) .. ']/m1.d')
    wire 'm1.q/s1.a[1]'
end

Or 'out'
wire 's0.q/out.a[0]'
wire 's1.q/out.a[1]'
