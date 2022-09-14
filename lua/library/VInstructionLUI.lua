input '!rst'
input 'clk'
input 'pause'
input 'ischedule'
input '!LUI'

output 'legal'
output 'icomplete'
output '!rd_oe'
output '!imm_u'
output '!alu_oe'
output 'pc_we'
output 'pc_count'

X7404 { 'LUI', width = 1 }
wire '!LUI/LUI.a'

X7400 { '!legal', width = 1 }
wire '!legal.a/ischedule'
wire '!legal.b/LUI.q'

X7404 { 'legal', width = 1 }
wire '!legal.q/legal.a'

X74245 { 'control', width = 6 }
wire 'VCC/control.dir'
wire '!legal.q/control.!oe'

wire 'VCC/control.a[0]'
wire 'control.b[0]/legal'

wire 'GND/control.a[1]'
wire 'control.b[1]/!rd_oe'

wire 'GND/control.a[2]'
wire 'control.b[2]/!imm_u'

wire 'GND/control.a[3]'
wire 'control.b[3]/!alu_oe'

wire 'VCC/control.a[4]'
wire 'control.b[4]/pc_we'

wire 'VCC/control.a[5]'
wire 'control.b[5]/pc_count'

VControlStage { 'icomplete', width = 1 }
wire 'pause/icomplete.pause'
wire '!rst/icomplete.!mr'
wire 'clk/icomplete.clk'
wire 'legal.q/icomplete.in'
wire 'VCC/icomplete.din'
wire 'icomplete.dout/icomplete'
