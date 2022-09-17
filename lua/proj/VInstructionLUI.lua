input '!rst'
input 'clk'
input 'ischedule'
input '!LUI'

output 'legal'
output 'icomplete'
output '!rd_oe'
output '!imm_u'
output '!alu_oe'
output 'pc_we'

X7404 { 'LUI', width = 1 }
wire '!LUI/LUI.a'

X7400 { '!legal', width = 1 }
wire '!legal.a/ischedule'
wire '!legal.b/LUI.q'

X7404 { 'legal', width = 1 }
wire '!legal.q/legal.a'

X74245 { 'control', width = 5 }
wire 'VCC/control.dir'
wire '!legal.q/control.!oe'
fan 'VCC/control.a[0-1]'
wire 'control.b[0]/legal'
wire 'control.b[1]/pc_we'
fan 'GND/control.a[2-4]'
wire 'control.b[2]/!rd_oe'
wire 'control.b[3]/!imm_u'
wire 'control.b[4]/!alu_oe'

VControlStage { 'icomplete', width = 1 }
wire '!rst/icomplete.!mr'
wire 'clk/icomplete.clk'
wire 'legal.q/icomplete.in'
wire 'VCC/icomplete.din'
wire 'icomplete.dout/icomplete'
