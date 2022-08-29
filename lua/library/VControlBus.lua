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
Pulldown '!alu_oe'
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
Pulldown 'pc_count'
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

output 'pause'
Pulldown 'pause'
wire 'pause.q/pause'
