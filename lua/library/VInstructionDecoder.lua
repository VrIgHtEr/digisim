input 'w'
input '!mr'
input 'clk'
input('d', 31)
output('instr', 31)
output 'short'

High 'VCC'
Low 'GND'

X7400 { 'short', width = 1 }
wire 'd[0]/short.a[0]'
wire 'd[1]/short.b[0]'
--
X74157 { 'in', width = 32 }
wire 'd/in.a'
fan 'GND.q/in.b'
wire 'GND.q/in.!e'
wire 'short.q[0]/in.s'

VRegister { 'instr', width = 33 }
wire '!mr/instr.!mr'
wire 'clk/instr.cp'
wire 'w/instr.w'
wire 'instr/instr.out[0-31]'
wire 'in.q/instr.in[0-31]'
wire 'short.q/instr.in[32]'
wire 'short/instr.out[32]'
