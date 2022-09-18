input '!rst'
input 'clk'
input 'ischedule'
input '!AUIPC'
input '!LUI'
input 'i5'

output 'legal'
output 'icomplete'
output '!rd_oe'
output '!imm_u'
output '!alu_oe'
output 'pc_we'
output '!pc_oe'

X7486 { 'valid', width = 1 }
wire '!AUIPC/valid.a'
wire '!LUI/valid.b'

X7400 { '!legal', width = 1 }
wire '!legal.a/ischedule'
wire '!legal.b/valid.q'
--
X7404 { 'legal', width = 1 }
wire '!legal.q/legal.a'

X74245 { 'control1', width = 6 }
wire 'VCC/control1.dir'
wire '!legal.q/control1.!oe'
fan 'VCC/control1.a[0-1]'
wire 'control1.b[0]/legal'
wire 'control1.b[1]/pc_we'
fan 'GND/control1.a[2-4]'
wire 'control1.b[2]/!imm_u'
wire 'control1.b[3]/!rd_oe'
wire 'control1.b[4]/!alu_oe'
fan 'i5/control1.a[5]'
wire 'control1.b[5]/!pc_oe'

VControlStage { 'icomplete', width = 1 }
wire '!rst/icomplete.!mr'
wire 'clk/icomplete.clk'
wire 'legal.q/icomplete.in'
wire 'VCC/icomplete.din'
wire 'icomplete.dout/icomplete'
