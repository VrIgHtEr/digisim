input '!rst'
input 'clk'
input 'pause'
input 'icomplete'
input 'int'
input 'mar0'
input 'legal'

output 'trap'
output('cause', 4)
output 'ischedule'
output '!pc_oe'
output 'mar_in'
output '!mem_word'
output '!mem_half'
output '!mem_ce'
output '!mem_oe'
output 'ir_in'

-------------------------------------------------------------------
-- if an interrupt is not pending and an instruction has been completed
-- then load PC into MAR

X7404 { '!int', width = 1 }
wire 'int/!int.a'

X7408 { 's0c', width = 1 }
wire 's0c.a/!int.q'
wire 's0c.b/icomplete'

X7404 { '!s0c', width = 1 }
wire 's0c.q/!s0c.a'

X74245 { 's0', width = 2 }
wire '!s0c.q/s0.!oe'
wire 'VCC/s0.dir'
wire 'GND/s0.a[0]'
wire 's0.b[0]/!pc_oe'
wire 'VCC/s0.a[1]'
wire 's0.b[1]/mar_in'

-------------------------------------------------------------------
-- if value in mar is misaligned then trap 0

X7408 { 'trapc', width = 1 }
wire 'trapc.a/s0c.q'
wire 'trapc.b/mar0'

VControlStage { 'strap', width = 1 }
wire 'pause/strap.pause'
wire '!rst/strap.!mr'
wire 'clk/strap.clk'
wire 'trapc.q/strap.in'
fan 'VCC/strap.din'
wire 'strap.dout/trap'

-------------------------------------------------------------------
-- if value in mar is aligned then load word into IR

X7404 { '!mar0', width = 1 }
wire 'mar0/!mar0.a'

X7408 { 's1c', width = 1 }
wire 's1c.a/s0c.q'
wire 's1c.b/!mar0.q'

VControlStage { 's1', width = 5 }
wire 'pause/s1.pause'
wire '!rst/s1.!mr'
wire 'clk/s1.clk'
wire 's1c.q/s1.in'
fan 'GND/s1.din[0-3]'
wire 's1.dout[0]/!mem_word'
wire 's1.dout[1]/!mem_half'
wire 's1.dout[2]/!mem_ce'
wire 's1.dout[3]/!mem_oe'
wire 'VCC/s1.din[4]'
wire 's1.dout[4]/ir_in'

-------------------------------------------------------------------
-- after IR is loaded, schedule the instruction

VControlStage { 's2', width = 1 }
wire 'pause/s2.pause'
wire '!rst/s2.!mr'
wire 'clk/s2.clk'
wire 's1.out/s2.in'
wire 'VCC/s2.din'
wire 's2.dout/ischedule'

-------------------------------------------------------------------
-- if an illegal instruction is scheduled
-- then trap 2

X7404 { '!legal', width = 1 }
wire '!legal.a/legal'

X7400 { 'illegal', width = 1 }
wire 'illegal.a/!legal.q'
wire 'illegal.b/s2.out'

X74245 { 'sillegal', width = 2 }
wire 'illegal.q/sillegal.!oe'
wire 'VCC/sillegal.dir'
fan 'VCC/sillegal.a'
wire 'sillegal.b[0]/cause[1]'
wire 'sillegal.b[1]/trap'
