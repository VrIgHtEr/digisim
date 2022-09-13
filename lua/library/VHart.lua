input '!rst'
input 'clk'
input 'pause'
input 'icomplete'
input 'int'
input 'trap'

output 'ischedule'
output '!pc_oe'
output 'mar_in'
output '!mem_word'
output '!mem_half'
output '!mem_ce'
output '!mem_oe'
output 'ir_in'

Low 'GND'
High 'VCC'

X7404 { '!trapint', width = 2 }
wire 'trap/!trapint.a[0]'
wire 'int/!trapint.a[1]'

-------------------------------------------------------------------

X7408 { 's0c', width = 1 }
wire 's0c.a/!trapint.q[1]'
wire 's0c.b/icomplete'

X7404 { '!s0c', width = 1 }
wire 's0c.q/!s0c.a'

X74245 { 's0', width = 2 }
wire '!s0c.q/s0.!oe'
wire 'VCC.q/s0.dir'
wire 'GND.q/s0.a[0]'
wire 's0.b[0]/!pc_oe'
wire 'VCC.q/s0.a[1]'
wire 's0.b[1]/mar_in'

-------------------------------------------------------------------

X7408 { 's1c', width = 1 }
wire 's1c.a/s0c.q'
wire 's1c.b/!trapint.q[0]'

VControlStage { 's1', width = 5 }
wire 'pause/s1.pause'
wire '!rst/s1.!mr'
wire 'clk/s1.clk'
wire 's1c.q/s1.in'
fan 'GND.q/s1.din[0-3]'
wire 's1.dout[0]/!mem_word'
wire 's1.dout[1]/!mem_half'
wire 's1.dout[2]/!mem_ce'
wire 's1.dout[3]/!mem_oe'
wire 'VCC.q/s1.din[4]'
wire 's1.dout[4]/ir_in'

VControlStage { 's2', width = 1 }
wire 'pause/s2.pause'
wire '!rst/s2.!mr'
wire 'clk/s2.clk'
wire 's1.out/s2.in'
wire 'VCC.q/s2.din'
wire 's2.dout/ischedule'
