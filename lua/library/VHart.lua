input '!rst'
input 'clk'
input 'icomplete'
input 'int'
input 'mar0'
input 'legal'

output 'trap'
output('d', 31)
output 'ischedule'
output '!pc_oe'
output 'mar_in'
output '!mem_word'
output '!mem_half'
output '!mem_ce'
output '!mem_oe'
output 'ir_in'
output 'mcause_in'
output 'mepc_in'
output 'mtval_in'
output 'pc_we'
output 'pc_count'

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
wire 'sillegal.b[0]/d[1]'
wire 'sillegal.b[1]/trap'

-------------------------------------------------------------------
-- trap handling

X7404 { '!trap', width = 1 }
wire 'trap/!trap.a'

X74245 { 'trap0', width = 1 }
wire '!trap.q/trap0.!oe'
wire 'VCC/trap0.dir'
wire 'VCC/trap0.a[0]'
wire 'trap0.b[0]/mcause_in'

VControlStage { 'trap1', width = 2 }
wire '!rst/trap1.!mr'
wire 'clk/trap1.clk'
wire 'trap/trap1.in'
wire 'VCC/trap1.din[0]'
wire 'trap1.dout[0]/mepc_in'
wire 'GND/trap1.din[1]'
wire 'trap1.dout[1]/!pc_oe'

VControlStage { 'trap2', width = 2 }
wire '!rst/trap2.!mr'
wire 'clk/trap2.clk'
wire 'trap1.out/trap2.in'
wire 'VCC/trap2.din[0]'
wire 'trap2.dout[0]/pc_we'
wire 'GND/trap2.din[1]'
wire 'trap2.dout[1]/pc_count'

VControlStage { 'trap3', width = 1 }
wire '!rst/trap3.!mr'
wire 'clk/trap3.clk'
wire 'trap2.out/trap3.in'
wire 'VCC/trap3.din[0]'
wire 'trap3.dout[0]/mtval_in'

VControlStage { 'trap4', width = 1 }
wire '!rst/trap4.!mr'
wire 'clk/trap4.clk'
wire 'trap3.out/trap4.in'
wire 'VCC/trap4.din[0]'
wire 'trap4.dout[0]/icomplete'
