output '!rst'
Reset { '!rst', period = 100 }
wire '!rst.q/!rst'

output 'clk'
Clock { 'clk', period = 500 }
wire 'clk.q/clk'
X7404 { '!clk', width = 1 }
wire 'clk/!clk.a'
output '!clk'
wire '!clk.q/!clk'

output 'icomplete'

VControlStage 's'
wire '!rst/s.!mr'
wire '!clk/s.clk'
wire 'VCC/s.in'

X7404 { '!started', width = 1 }
wire 's.out/!started.a'

output 'd2'
output 'pc_we'
output 'pc_count'

VControlStage { 's1', width = 3 }
wire '!rst/s1.!mr'
wire '!clk/s1.clk'
wire '!started.q/s1.in'
fan 'VCC/s1.din[0-1]'
wire 's1.dout[0]/pc_we'
wire 's1.dout[1]/d2'
fan 'GND/s1.din[2]'
wire 's1.dout[2]/pc_count'

VControlStage { 's2', width = 1 }
wire '!rst/s2.!mr'
wire '!clk/s2.clk'
wire 's1.out/s2.in'
wire 'VCC/s2.din[0]'
wire 's2.dout[0]/icomplete'
