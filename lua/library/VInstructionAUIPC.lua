input '!rst'
input 'clk'
input 'ischedule'
input '!AUIPC'

output 'legal'
output 'icomplete'
output '!rd_oe'
output '!imm_u'
output '!alu_oe'
output '!rd_rs1_oe'
output 'pc_we'
output '!pc_oe'

X7404 { 'AUIPC', width = 1 }
wire '!AUIPC/AUIPC.a'

X7400 { '!legal', width = 1 }
wire '!legal.a/ischedule'
wire '!legal.b/AUIPC.q'
--
X7404 { 'legal', width = 1 }
wire '!legal.q/legal.a'

X74245 { 'control1', width = 3 }
wire 'VCC/control1.dir'
wire '!legal.q/control1.!oe'
fan 'VCC/control1.a[0]'
wire 'control1.b[0]/legal'
fan 'GND/control1.a[1-2]'
wire 'control1.b[1]/!rd_oe'
wire 'control1.b[2]/!pc_oe'

VControlStage { 'control2', width = 5 }
wire '!rst/control2.!mr'
wire 'clk/control2.clk'
wire 'legal.q/control2.in'
fan 'VCC/control2.din[0]'
wire 'control2.dout[0]/pc_we'
fan 'GND/control2.din[1-4]'
wire 'control2.dout[1]/!alu_oe'
wire 'control2.dout[2]/!rd_rs1_oe'
wire 'control2.dout[3]/!rd_oe'
wire 'control2.dout[4]/!imm_u'

VControlStage { 'icomplete', width = 1 }
wire '!rst/icomplete.!mr'
wire 'clk/icomplete.clk'
wire 'control2.out/icomplete.in'
wire 'VCC/icomplete.din'
wire 'icomplete.dout/icomplete'
