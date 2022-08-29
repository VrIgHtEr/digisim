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

X7404 { '!pause', width = 1 }
wire 'pause/!pause.a'
X7432 { 'sin', width = 1 }
wire '!pause.q/sin.a'
VControlStage 's'
wire '!rst/s.!mr'
wire 'clk/s.clk'
wire 'pause/s.pause'
wire 'sin.q/s.in'
wire 's.out/sin.b'
