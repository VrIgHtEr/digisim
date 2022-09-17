input '!rst'
input 'clk'
input 'ischedule'
input '!JAL'
input '!JALR'
input 'i3'
input('f3', 2)

output 'legal'
output 'icomplete'
output 'pc_we'
output 'mar_in'
output 'pc_count'
output '!pc_oe'
output '!rs1_oe'
output '!imm_j'
output '!imm_i'
output '!alu_oe'
output '!rd_oe'
output '!mar_out'

X7432 { 'JALR', width = 3 }
wire '!JALR/JALR.a[1]'
wire 'f3[0]/JALR.a[2]'
wire 'f3[1]/JALR.b[1]'
wire 'f3[2]/JALR.b[2]'
wire 'JALR.q[1]/JALR.a[0]'
wire 'JALR.q[2]/JALR.b[0]'

X7400 { 'valid', width = 1 }
wire '!JAL/valid.a'
wire 'JALR.q[0]/valid.b'

X7400 { '!legal', width = 1 }
wire '!legal.a/ischedule'
wire '!legal.b/valid.q'

X7400 { 'legal', width = 1 }
wire '!legal.q/legal.a'
wire '!legal.q/legal.b'

X7400 { '!i3', width = 1 }
wire 'i3/!i3.a'
wire 'i3/!i3.b'

X74245 { 'control1', width = 8 }
wire 'VCC/control1.dir'
wire '!legal.q/control1.!oe'
fan 'VCC/control1.a[0-2]'
wire 'control1.b[0]/legal'
wire 'control1.b[1]/pc_we'
wire 'control1.b[2]/mar_in'
fan 'GND/control1.a[3]'
wire 'control1.b[3]/!alu_oe'
fan '!i3.q/control1.a[4-5]'
wire 'control1.b[4]/!pc_oe'
wire 'control1.b[5]/!imm_j'
fan 'i3/control1.a[6-7]'
wire 'control1.b[6]/!rs1_oe'
wire 'control1.b[7]/!imm_i'

VControlStage { 'control2', width = 3 }
wire '!rst/control2.!mr'
wire 'clk/control2.clk'
wire 'legal.q/control2.in'
fan 'VCC/control2.din[0-2]'
wire 'control2.dout[0]/!pc_oe'
wire 'control2.dout[1]/!rd_oe'
wire 'control2.dout[2]/!alu_oe'

VControlStage { 'control3', width = 3 }
wire '!rst/control3.!mr'
wire 'clk/control3.clk'
wire 'control2.out/control3.in'
fan 'VCC/control3.din[0]'
wire 'control3.dout[0]/pc_we'
fan 'GND/control3.din[1-2]'
wire 'control3.dout[1]/!mar_out'
wire 'control3.dout[2]/pc_count'

VControlStage { 'icomplete', width = 1 }
wire '!rst/icomplete.!mr'
wire 'clk/icomplete.clk'
wire 'control3.out/icomplete.in'
fan 'VCC/icomplete.din[0]'
wire 'icomplete.dout[0]/icomplete'
