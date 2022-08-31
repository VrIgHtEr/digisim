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

High 'VCC'
input 'pause'
output 'icomplete'

X7404 { '!pause', width = 1 }
wire 'pause/!pause.a'
X7432 { 'sin', width = 1 }
wire '!pause.q/sin.a'
VControlStage 's'
wire '!rst/s.!mr'
wire '!clk/s.clk'
wire 'pause/s.pause'
wire 'sin.q/s.in'
wire 's.out/sin.b'

X7404 { '!started', width = 1 }
wire 's.out/!started.a'

output 'd2'
output 'pc_we'

VControlStage { 's1', width = 2 }
wire '!rst/s1.!mr'
wire '!clk/s1.clk'
wire 'pause/s1.pause'
wire '!started.q/s1.in'
fan 'VCC.q/s1.din'
wire 's1.dout[0]/pc_we'
wire 's1.dout[1]/d2'

VControlStage { 's2', width = 1 }
wire '!rst/s2.!mr'
wire '!clk/s2.clk'
wire 'pause/s2.pause'
wire 's1.out/s2.in'
wire 'VCC.q/s2.din[0]'
wire 's2.dout[0]/icomplete'
