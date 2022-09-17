input '!e0'
input '!e1'
input('a', 3)
output('y', 15)

LineDecoder { 'dec', selwidth = 4, enable_pins = 2, active_low = true }
wire '!e0/dec.!e0'
wire '!e1/dec.!e1'
wire 'a/dec.a'
wire 'y/dec.!y'
