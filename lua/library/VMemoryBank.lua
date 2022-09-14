input '!ce'
input '!oe'
input '!we'
input('a', 29)
output('d', 7)

X74139 'csm'
wire 'GND/csm.!ea'
wire 'a[0-1]/csm.sa'
wire 'VCC/csm.!eb'
fan 'VCC/csm.sb'

X7432 { 'cso', width = 4 }
fan '!ce/cso.a'
wire 'csm.!qa/cso.b'

Sram 'm0'
wire '!oe/m0.!oe'
wire '!we/m0.!we'
wire 'cso.q[0]/m0.!ce'
wire 'a[2-20]/m0.a'
wire 'd/m0.d'

Sram 'm1'
wire '!oe/m1.!oe'
wire '!we/m1.!we'
wire 'cso.q[1]/m1.!ce'
wire 'a[2-20]/m1.a'
wire 'd/m1.d'

Sram 'm2'
wire '!oe/m2.!oe'
wire '!we/m2.!we'
wire 'cso.q[2]/m2.!ce'
wire 'a[2-20]/m2.a'
wire 'd/m2.d'

Sram 'm3'
wire '!oe/m3.!oe'
wire '!we/m3.!we'
wire 'cso.q[3]/m3.!ce'
wire 'a[2-20]/m3.a'
wire 'd/m3.d'
