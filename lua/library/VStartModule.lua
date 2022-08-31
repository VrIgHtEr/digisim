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

VControlStage 's1'
wire '!rst/s1.!mr'
wire '!clk/s1.clk'
wire 'pause/s1.pause'
wire '!started.q/s1.in'

VControlStage 's2'
wire '!rst/s2.!mr'
wire '!clk/s2.clk'
wire 'pause/s2.pause'
wire 's1.out/s2.in'
