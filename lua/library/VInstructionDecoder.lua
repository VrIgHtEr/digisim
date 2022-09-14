input 'w'
input '!mr'
input 'clk'
input('d', 31)
input '!imm_i'
input '!imm_s'
input '!imm_b'
input '!imm_u'
input '!imm_j'
input '!rs1_oe'
input '!rs2_oe'
input '!rd_oe'
output('instr', 31)
output 'short'
output('imm', 31)
output('rs1', 4)
output('rs2', 4)
output('rd', 4)

output 'LOAD'
output 'STORE'
output 'MADD'
output 'BRANCH'
output 'LOADFP'
output 'STOREFP'
output 'MSUB'
output 'JALR'
output 'CUSTOM0'
output 'CUSTOM1'
output 'NMSUB'
output 'RESERVED0'
output 'MISCMEM'
output 'AMO'
output 'NMADD'
output 'JAL'
output 'OPIMM'
output 'OP'
output 'OPFP'
output 'SYSTEM'
output 'AUIPC'
output 'LUI'
output 'RESERVED1'
output 'RESERVED2'
output 'OPIMM32'
output 'OP32'
output 'CUSTOM2'
output 'CUSTOM3'
output 'F7Z'

X7400 { 'short', width = 1 }
wire 'd[0]/short.a[0]'
wire 'd[1]/short.b[0]'
--
X74157 { 'in', width = 32 }
wire 'd/in.a'
fan 'GND/in.b'
wire 'GND/in.!e'
wire 'short.q[0]/in.s'

VRegister { 'instr', width = 33 }
wire '!mr/instr.!mr'
wire 'clk/instr.cp'
wire 'w/instr.w'
wire 'instr/instr.out[0-31]'
wire 'in.q/instr.in[0-31]'
wire 'short.q/instr.in[32]'
wire 'short/instr.out[32]'

X7400 { 'l', width = 1 }
wire 'instr[0]/l.a'
wire 'instr[1]/l.b'

X74138 'col'
wire 'l.q/col.!e1'
wire 'GND/col.!e2'
wire 'VCC/col.e3'
wire 'instr[2-4]/col.a'

X74139 'col01'
wire 'col01.sa/instr[5-6]'
wire 'col01.sb/instr[5-6]'
wire 'col01.!ea/col.!y[0]'
wire 'col01.!eb/col.!y[1]'
wire 'col01.!qa[0]/LOAD'
wire 'col01.!qa[1]/STORE'
wire 'col01.!qa[2]/MADD'
wire 'col01.!qa[3]/BRANCH'
wire 'col01.!qb[0]/LOADFP'
wire 'col01.!qb[1]/STOREFP'
wire 'col01.!qb[2]/MSUB'
wire 'col01.!qb[3]/JALR'

X74139 'col23'
wire 'col23.sa/instr[5-6]'
wire 'col23.sb/instr[5-6]'
wire 'col23.!ea/col.!y[2]'
wire 'col23.!eb/col.!y[3]'
wire 'col23.!qa[0]/CUSTOM0'
wire 'col23.!qa[1]/CUSTOM1'
wire 'col23.!qa[2]/NMSUB'
wire 'col23.!qa[3]/RESERVED0'
wire 'col23.!qb[0]/MISCMEM'
wire 'col23.!qb[1]/AMO'
wire 'col23.!qb[2]/NMADD'
wire 'col23.!qb[3]/JAL'

X74139 'col45'
wire 'col45.sa/instr[5-6]'
wire 'col45.sb/instr[5-6]'
wire 'col45.!ea/col.!y[4]'
wire 'col45.!eb/col.!y[5]'
wire 'col45.!qa[0]/OPIMM'
wire 'col45.!qa[1]/OP'
wire 'col45.!qa[2]/OPFP'
wire 'col45.!qa[3]/SYSTEM'
wire 'col45.!qb[0]/AUIPC'
wire 'col45.!qb[1]/LUI'
wire 'col45.!qb[2]/RESERVED1'
wire 'col45.!qb[3]/RESERVED2'

X74139 'col6'
wire 'col6.sa/instr[5-6]'
fan 'GND/col6.sb'
wire 'col6.!ea/col.!y[6]'
wire 'col6.!eb/VCC'
wire 'col6.!qa[0]/OPIMM32'
wire 'col6.!qa[1]/OP32'
wire 'col6.!qa[2]/CUSTOM2'
wire 'col6.!qa[3]/CUSTOM3'

X7404 { '!f7', width = 6 }
wire 'instr[25-29]/!f7.a[0-4]'
wire 'instr[31]/!f7.a[5]'
Nand { 'F7Z', width = 6 }
wire '!f7.q/F7Z.a'
wire 'F7Z.q/F7Z'

X74245 { 'imm_i', width = 32 }
wire 'imm_i.!oe/!imm_i'
wire 'VCC/imm_i.dir'
wire 'imm_i.b/imm'
wire 'instr[20-31]/imm_i.a[0-11]'
fan 'instr[31]/imm_i.a[12-31]'

X74245 { 'imm_s', width = 32 }
wire 'imm_s.!oe/!imm_s'
wire 'VCC/imm_s.dir'
wire 'imm_s.b/imm'
wire 'instr[7-11]/imm_s.a[0-4]'
wire 'instr[25-31]/imm_s.a[5-11]'
fan 'instr[31]/imm_s.a[12-31]'

X74245 { 'imm_b', width = 32 }
wire 'imm_b.!oe/!imm_b'
wire 'VCC/imm_b.dir'
wire 'imm_b.b/imm'
fan 'GND/imm_b.a[0]'
wire 'instr[8-11]/imm_b.a[1-4]'
wire 'instr[25-30]/imm_b.a[5-10]'
wire 'instr[7]/imm_b.a[11]'
fan 'instr[31]/imm_b.a[12-31]'

X74245 { 'imm_u', width = 32 }
wire 'imm_u.!oe/!imm_u'
wire 'VCC/imm_u.dir'
wire 'imm_u.b/imm'
fan 'GND/imm_u.a[0-11]'
wire 'instr[12-31]/imm_u.a[12-31]'

X74245 { 'imm_j', width = 32 }
wire 'imm_j.!oe/!imm_j'
wire 'VCC/imm_j.dir'
wire 'imm_j.b/imm'
wire 'GND/imm_j.a[0]'
wire 'instr[21-30]/imm[1-10]'
wire 'instr[20]/imm[11]'
wire 'instr[12-19]/imm[12-19]'
fan 'instr[31]/imm[20-31]'

X74245 { 'rs1', width = 5 }
wire 'rs1.!oe/!rs1_oe'
wire 'VCC/rs1.dir'
wire 'rs1.b/rs1'
wire 'rs1.a/instr[15-19]'

X74245 { 'rs2', width = 5 }
wire 'rs2.!oe/!rs2_oe'
wire 'VCC/rs2.dir'
wire 'rs2.b/rs2'
wire 'rs2.a/instr[20-24]'

X74245 { 'rd', width = 5 }
wire 'rd.!oe/!rd_oe'
wire 'VCC/rd.dir'
wire 'rd.b/rd'
wire 'rd.a/instr[7-11]'
