local trace = opts.trace and true or false
input 'clk'
input '!clk'

output('!rst', trace)
Pullup '!rst'
wire '!rst.q/!rst'

output('!mem_ce', trace)
Pullup '!mem_ce'
wire '!mem_ce.q/!mem_ce'

output('!mem_we', trace)
Pullup '!mem_we'
wire '!mem_we.q/!mem_we'

output('!mem_oe', trace)
Pullup '!mem_oe'
wire '!mem_oe.q/!mem_oe'

output('!mem_half', trace)
Pullup '!mem_half'
wire '!mem_half.q/!mem_half'

output('!mem_word', trace)
Pullup '!mem_word'
wire '!mem_word.q/!mem_word'

output('mem_signed', trace)
Pulldown 'mem_signed'
wire 'mem_signed.q/mem_signed'

output('!mar_out', trace)
Pullup '!mar_out'
wire '!mar_out.q/!mar_out'

output('mar_in', trace)
Pulldown 'mar_in'
wire 'mar_in.q/mar_in'

output('ir_in', trace)
Pulldown 'ir_in'
wire 'ir_in.q/ir_in'

output('alu_sub', trace)
Pulldown 'alu_sub'
wire 'alu_sub.q/alu_sub'

output('!alu_oe', trace)
Pullup '!alu_oe'
wire '!alu_oe.q/!alu_oe'

output('alu_op', 2)
Pulldown { 'alu_op', width = 3 }
wire 'alu_op.q/alu_op'

output('alu_signed', trace)
Pullup 'alu_signed'
wire 'alu_signed.q/alu_signed'

output('alu_lt', trace)
Pulldown 'alu_lt'
wire 'alu_lt.q/alu_lt'

output('alu_eq', trace)
Pulldown 'alu_eq'
wire 'alu_eq.q/alu_eq'

output('alu_gt', trace)
Pulldown 'alu_gt'
wire 'alu_gt.q/alu_gt'

output('!pc_oe', trace)
Pullup '!pc_oe'
wire '!pc_oe.q/!pc_oe'

output('pc_short', trace)
Pulldown 'pc_short'
wire 'pc_short.q/pc_short'

output('pc_we', trace)
Pulldown 'pc_we'
wire 'pc_we.q/pc_we'

output('pc_count', trace)
Pullup 'pc_count'
wire 'pc_count.q/pc_count'

output('rs1', 4)
Pulldown { 'rs1', width = 5 }
wire 'rs1.q/rs1'

output('rs2', 4)
Pulldown { 'rs2', width = 5 }
wire 'rs2.q/rs2'

output('rd', 4)
Pulldown { 'rd', width = 5 }
wire 'rd.q/rd'

output('!imm_i', trace)
Pullup '!imm_i'
wire '!imm_i.q/!imm_i'

output('!imm_s', trace)
Pullup '!imm_s'
wire '!imm_s.q/!imm_s'

output('!imm_b', trace)
Pullup '!imm_b'
wire '!imm_b.q/!imm_b'

output('!imm_u', trace)
Pullup '!imm_u'
wire '!imm_u.q/!imm_u'

output('!imm_j', trace)
Pullup '!imm_j'
wire '!imm_j.q/!imm_j'

output('!rs1_oe', trace)
Pullup '!rs1_oe'
wire '!rs1_oe.q/!rs1_oe'

output('!rs2_oe', trace)
Pullup '!rs2_oe'
wire '!rs2_oe.q/!rs2_oe'

output('!rd_oe', trace)
Pullup '!rd_oe'
wire '!rd_oe.q/!rd_oe'

output('icomplete', trace)
Pulldown 'icomplete'
wire 'icomplete.q/icomplete'

output('ischedule', trace)
Pulldown 'ischedule'
wire 'ischedule.q/ischedule'

output('int', trace)
Pulldown 'int'
wire 'int.q/int'

output('trap', trace)
Pulldown 'trap'
wire 'trap.q/trap'

output('legal', trace)
Pulldown 'legal'
wire 'legal.q/legal'

output('!mcause_out', trace)
Pullup '!mcause_out'
wire '!mcause_out.q/!mcause_out'

output('mcause_in', trace)
Pulldown 'mcause_in'
wire 'mcause_in.q/mcause_in'

output('!mepc_out', trace)
Pullup '!mepc_out'
wire '!mepc_out.q/!mepc_out'

output('mepc_in', trace)
Pulldown 'mepc_in'
wire 'mepc_in.q/mepc_in'

output('!mtval_out', trace)
Pullup '!mtval_out'
wire '!mtval_out.q/!mtval_out'

output('mtval_in', trace)
Pulldown 'mtval_in'
wire 'mtval_in.q/mtval_in'

output('!pc_oe_a', trace)
Pullup '!pc_oe_a'
wire '!pc_oe_a.q/!pc_oe_a'
