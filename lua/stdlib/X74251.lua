input '!oe'
input('s', 2)
input('d', 7)
output 'q'
output '!q'

Multiplexer { 'm', width = 3 }
wire 's/m.sel'
wire 'd/m.d'

Not 'nq'
wire 'm.q/nq.a'

X74541 { 'out', width = 2 }
wire 'm.q/out.a[0]'
wire 'nq.q/out.a[1]'
wire '!oe/out.!oe1'
wire 'GND/out.!oe2'
wire 'out.b[0]/q'
wire 'out.b[1]/!q'
