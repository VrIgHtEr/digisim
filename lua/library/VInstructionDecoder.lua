input 'w'
input '!mr'
input 'clk'
input('d', 31)
output('instr', 31)
output 'short'

High 'VCC'
Low 'GND'

X7400 { 'short', width = 2 }
wire 'd[0]/short.a[0]'
wire 'd[1]/short.b[0]'
wire 'instr[0]/short.a[1]'
wire 'instr[1]/short.b[1]'
wire 'short.q[1]/short'
--
X74157 { 'in', width = 32 }
wire 'd/in.a'
fan 'GND.q/in.b'
wire 'GND.q/in.!e'
wire 'short.q[0]/in.s'

VRegister { 'instr', width = 32 }
wire '!mr/instr.!mr'
wire 'clk/instr.cp'
wire 'w/instr.w'
wire 'instr/instr.out'
wire 'in.q/instr.in'
