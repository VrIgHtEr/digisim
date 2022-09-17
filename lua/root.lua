local l, z, h = sig.low, sig.z, sig.high

VControlBus { 'ctrl', trace = true }
VDataBus { 'data', trace = true }
VDecodeBus { 'decode', trace = true }

VStartModule 'start'
wire 'ctrl.clk/start.clk'
wire 'ctrl.!rst/start.!rst'
wire 'ctrl.!clk/start.!clk'
wire 'ctrl.icomplete/start.icomplete'
wire 'start.d6/data.d[6]'
wire 'start.pc_we/ctrl.pc_we'
wire 'start.pc_count/ctrl.pc_count'
wire 'start.icomplete/ctrl.icomplete'

VHart 'hart'
wire 'ctrl.!clk/hart.clk'
wire 'ctrl.!rst/hart.!rst'
wire 'ctrl.icomplete/hart.icomplete'
wire 'ctrl.!pc_oe/hart.!pc_oe'
wire 'ctrl.!alu_oe/hart.!alu_oe'
wire 'ctrl.mar_in/hart.mar_in'
wire 'ctrl.!mem_word/hart.!mem_word'
wire 'ctrl.!mem_half/hart.!mem_half'
wire 'ctrl.!mem_ce/hart.!mem_ce'
wire 'ctrl.!mem_oe/hart.!mem_oe'
wire 'ctrl.ir_in/hart.ir_in'
wire 'ctrl.ischedule/hart.ischedule'
wire 'ctrl.int/hart.int'
wire 'ctrl.trap/hart.trap'
wire 'ctrl.legal/hart.legal'
wire 'ctrl.mcause_in/hart.mcause_in'
wire 'ctrl.mepc_in/hart.mepc_in'
wire 'ctrl.mtval_in/hart.mtval_in'
wire 'ctrl.pc_we/hart.pc_we'
wire 'ctrl.pc_count/hart.pc_count'
wire 'data.d/hart.d'

VInstructionLUI 'ILUI'
wire 'ctrl.!rst/ILUI.!rst'
wire 'ctrl.!clk/ILUI.clk'
wire 'ctrl.ischedule/ILUI.ischedule'
wire 'ctrl.icomplete/ILUI.icomplete'
wire 'ctrl.legal/ILUI.legal'
wire 'ctrl.!rd_oe/ILUI.!rd_oe'
wire 'ctrl.!imm_u/ILUI.!imm_u'
wire 'ctrl.!alu_oe/ILUI.!alu_oe'
wire 'ctrl.pc_we/ILUI.pc_we'
wire 'decode.LUI/ILUI.!LUI'

VInstructionAUIPC 'IAUIPC'
wire 'ctrl.!rst/IAUIPC.!rst'
wire 'ctrl.!clk/IAUIPC.clk'
wire 'ctrl.ischedule/IAUIPC.ischedule'
wire 'ctrl.icomplete/IAUIPC.icomplete'
wire 'ctrl.legal/IAUIPC.legal'
wire 'ctrl.!rd_oe/IAUIPC.!rd_oe'
wire 'ctrl.!imm_u/IAUIPC.!imm_u'
wire 'ctrl.!alu_oe/IAUIPC.!alu_oe'
wire 'ctrl.pc_we/IAUIPC.pc_we'
wire 'ctrl.!pc_oe/IAUIPC.!pc_oe'
wire 'decode.AUIPC/IAUIPC.!AUIPC'

VMemoryInterface { 'mem', memory = mem 'rom' }
wire 'ctrl.clk/mem.clk'
wire 'ctrl.!rst/mem.!rst'
wire 'mem.!word/ctrl.!mem_word'
wire 'mem.!half/ctrl.!mem_half'
wire 'mem.!ce/ctrl.!mem_ce'
wire 'mem.!oe/ctrl.!mem_oe'
wire 'mem.!w/ctrl.!mem_we'
wire 'mem.signed/ctrl.mem_signed'
wire 'mem.a/data.address'
wire 'mem.d/data.d'

VMemoryAddressRegister 'mar'
wire 'mar.out/data.address'
wire 'mar.d/data.d'
wire 'ctrl.clk/mar.cp'
wire 'ctrl.!rst/mar.!mr'
wire 'ctrl.mar_in/mar.w'
wire 'ctrl.!mar_out/mar.!oe'

VInstructionDecoder 'ir'
wire 'ir.instr/data.instruction'
wire 'ir.d/data.d'
wire 'ir.imm/data.b'
wire 'ctrl.clk/ir.clk'
wire 'ctrl.!rst/ir.!mr'
wire 'ctrl.ir_in/ir.w'
wire 'ctrl.pc_short/ir.short'
wire 'ctrl.!imm_i/ir.!imm_i'
wire 'ctrl.!imm_s/ir.!imm_s'
wire 'ctrl.!imm_b/ir.!imm_b'
wire 'ctrl.!imm_u/ir.!imm_u'
wire 'ctrl.!imm_j/ir.!imm_j'
wire 'ctrl.!rd_oe/ir.!rd_oe'
wire 'ctrl.!rs1_oe/ir.!rs1_oe'
wire 'ctrl.!rs2_oe/ir.!rs2_oe'
wire 'ctrl.rd/ir.rd'
wire 'ctrl.rs1/ir.rs1'
wire 'ctrl.rs2/ir.rs2'
wire 'ir.LOAD/decode.LOAD'
wire 'ir.STORE/decode.STORE'
wire 'ir.MADD/decode.MADD'
wire 'ir.BRANCH/decode.BRANCH'
wire 'ir.LOADFP/decode.LOADFP'
wire 'ir.STOREFP/decode.STOREFP'
wire 'ir.MSUB/decode.MSUB'
wire 'ir.JALR/decode.JALR'
wire 'ir.CUSTOM0/decode.CUSTOM0'
wire 'ir.CUSTOM1/decode.CUSTOM1'
wire 'ir.NMSUB/decode.NMSUB'
wire 'ir.RESERVED0/decode.RESERVED0'
wire 'ir.MISCMEM/decode.MISCMEM'
wire 'ir.AMO/decode.AMO'
wire 'ir.NMADD/decode.NMADD'
wire 'ir.JAL/decode.JAL'
wire 'ir.OPIMM/decode.OPIMM'
wire 'ir.OP/decode.OP'
wire 'ir.OPFP/decode.OPFP'
wire 'ir.SYSTEM/decode.SYSTEM'
wire 'ir.AUIPC/decode.AUIPC'
wire 'ir.LUI/decode.LUI'
wire 'ir.RESERVED1/decode.RESERVED1'
wire 'ir.RESERVED2/decode.RESERVED2'
wire 'ir.OPIMM32/decode.OPIMM32'
wire 'ir.OP32/decode.OP32'
wire 'ir.CUSTOM2/decode.CUSTOM2'
wire 'ir.CUSTOM3/decode.CUSTOM3'
wire 'ir.F7Z/decode.F7Z'

VProgramCounter { 'pc', width = 32 }
wire 'ctrl.!rst/pc.!mr'
wire 'ctrl.!pc_oe/pc.!oe'
wire 'ctrl.pc_short/pc.short'
wire 'ctrl.pc_count/pc.count'
wire 'ctrl.pc_we/pc.we'
wire 'ctrl.clk/pc.clk'
wire 'data.d/pc.d'
wire 'data.a/pc.a'

VAlu 'alu'
wire 'data.a/alu.a'
wire 'data.b/alu.b'
wire 'data.d/alu.d'
wire 'ctrl.!alu_oe/alu.!oe'
wire 'ctrl.alu_sub/alu.sub'
wire 'ctrl.alu_op/alu.op'
wire 'ctrl.alu_signed/alu.signed'
wire 'alu.lt/ctrl.alu_lt'
wire 'alu.eq/ctrl.alu_eq'
wire 'alu.gt/ctrl.alu_gt'

VRegisterBank 'registers'
wire 'data.d/registers.d'
wire 'data.a/registers.a'
wire 'data.b/registers.b'
wire 'ctrl.clk/registers.clk'
wire 'ctrl.!rst/registers.!mr'
wire 'ctrl.rs1/registers.rs1'
wire 'ctrl.rs2/registers.rs2'
wire 'ctrl.rd/registers.rd'

VBusRegister 'MCAUSE'
wire 'data.d/MCAUSE.d'
wire 'ctrl.!rst/MCAUSE.!mr'
wire 'ctrl.clk/MCAUSE.cp'
wire 'ctrl.mcause_in/MCAUSE.w'
wire 'ctrl.!mcause_out/MCAUSE.!oe'

VBusRegister 'MEPC'
wire 'data.d/MEPC.d'
wire 'ctrl.!rst/MEPC.!mr'
wire 'ctrl.clk/MEPC.cp'
wire 'ctrl.mepc_in/MEPC.w'
wire 'ctrl.!mepc_out/MEPC.!oe'

VBusRegister 'MTVAL'
wire 'data.d/MTVAL.d'
wire 'ctrl.!rst/MTVAL.!mr'
wire 'ctrl.clk/MTVAL.cp'
wire 'ctrl.mtval_in/MTVAL.w'
wire 'ctrl.!mtval_out/MTVAL.!oe'
