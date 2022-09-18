input '!rst'
input 'clk'
input 'ischedule'
input '!BRANCH'
input('f3', 2)
input 'eq'
input 'lt'

output 'legal'
output 'icomplete'
output '!rs1_oe'
output '!rs2_oe'
output 'alu_signed'
output 'pc_we'
output 'pc_count'
output '!pc_oe'
output '!alu_oe'
output '!imm_b'

X7404 { 'signed', width = 1 }
wire 'f3[1]/signed.a'

X7404 { '!cond', width = 1 }
wire 'f3[2]/!cond.a'

X7402 { 'valid', width = 2 }
wire 'signed.q/valid.a[0]'
wire 'f3[2]/valid.b[0]'
wire 'valid.q[0]/valid.a[1]'
wire '!BRANCH/valid.b[1]'

X7400 { '!legal', width = 1 }
wire '!legal.a/ischedule'
wire '!legal.b/valid.q[1]'
--
X7404 { 'legal', width = 1 }
wire '!legal.q/legal.a'

-- set up check
X74245 { 'control1', width = 5 }
wire 'VCC/control1.dir'
wire '!legal.q/control1.!oe'
fan 'GND/control1.a[0-1]'
wire 'control1.b[0]/!rs1_oe'
wire 'control1.b[1]/!rs2_oe'
fan 'signed.q/control1.a[2]'
wire 'control1.b[2]/alu_signed'
fan 'VCC/control1.a[3-4]'
wire 'control1.b[3]/legal'
wire 'control1.b[4]/pc_we'

X7408 { 'eq', width = 1 }
wire 'eq/eq.a'
wire '!cond.q/eq.b'

X7408 { 'lt', width = 1 }
wire 'lt/lt.a'
wire 'f3[2]/lt.b'

X7432 { 'eqlt', width = 1 }
wire 'eq.q/eqlt.a'
wire 'lt.q/eqlt.b'

X7486 { 'c', width = 1 }
wire 'eqlt.q/c.a'
wire 'f3[0]/c.b'

X7404 { '!c', width = 1 }
wire 'c.q/!c.a'

X7408 { 'jump', width = 1 }
wire '!c.q/jump.a'
wire 'legal.q/jump.b'

X7408 { '!jump', width = 1 }
wire '!c.q/!jump.a'
wire 'legal.q/!jump.b'

VControlStage { 'control2', width = 5 }
wire '!rst/control2.!mr'
wire 'clk/control2.clk'
wire 'jump.q/control2.in'
fan 'VCC/control2.din[0]'
wire 'control2.dout[0]/pc_we'
fan 'GND/control2.din[1-4]'
wire 'control2.dout[1]/pc_count'
wire 'control2.dout[2]/!alu_oe'
wire 'control2.dout[3]/!imm_b'
wire 'control2.dout[4]/!pc_oe'

X7432 { 'complete', width = 1 }
wire '!jump.q/complete.a'
wire 'control2.out/complete.b'

VControlStage { 'icomplete', width = 1 }
wire '!rst/icomplete.!mr'
wire 'clk/icomplete.clk'
wire 'complete.q/icomplete.in'
wire 'VCC/icomplete.din'
wire 'icomplete.dout/icomplete'
