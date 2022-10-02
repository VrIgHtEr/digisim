local trace = opts.trace and true or false
input('!e0', trace)
input('!e1', trace)
input('a', 3, trace)
output('y', 15, trace)

LineDecoder { 'dec', selwidth = 4, enable_pins = 2, active_low = true }
wire '!e0/dec.!e0'
wire '!e1/dec.!e1'
wire 'a/dec.a'
wire 'y/dec.!y'
