input '!word'
input '!half'
input '!ce'
input '!oe'
input '!w'
input 'clk'
input 'signed'
input('a', 31)
output('d', 31)

High 'VCC'
Low 'GND'

-----------------------------------------------------------
-- four memory banks with 30-bit address and 8-bit data
VMemoryBank 'm0'
wire '!oe/m0.!oe'

VMemoryBank 'm1'
wire '!oe/m1.!oe'

VMemoryBank 'm2'
wire '!oe/m2.!oe'

VMemoryBank 'm3'
wire '!oe/m3.!oe'

-----------------------------------------------------------
-- write synchronization
Not '!clk'
wire '!clk.a/clk'
Or '!w'
wire '!w/!w.a[0]'
wire '!clk.q/!w.a[1]'
wire '!w.q/m0.!we'
wire '!w.q/m1.!we'
wire '!w.q/m2.!we'
wire '!w.q/m3.!we'

-----------------------------------------------------------
-- addresses for banks 0-2
-- increment bank 0 address if alignment > 0
Or 'c0'
wire 'a[0-1]/c0.a'
X74283 { 'a0', width = 30 }
wire 'c0.q/a0.cin'
wire 'a[2-31]/a0.a'
fan 'GND.q/a0.b'
wire 'a0.s/m0.a'

-- increment bank 1 address if alignment > 1
X74283 { 'a1', width = 30 }
wire 'a[1]/a1.cin'
wire 'a[2-31]/a1.a'
fan 'GND.q/a1.b'
wire 'a1.s/m1.a'

-- increment bank 2 address if alignment == 3
And 'c2'
wire 'a[0-1]/c2.a'
X74283 { 'a2', width = 30 }
wire 'c2.q/a2.cin'
wire 'a[2-31]/a2.a'
fan 'GND.q/a2.b'
wire 'a2.s/m2.a'

-- bank 3 never needs incrementing
-- only buffer for timing purposes
BufferBank { 'a3', width = 30, depth = 3 }
wire 'a[2-31]/a3.a'
wire 'a3.q/m3.a'

------------------------------------------------------------
-- chip enable signals for halfword (bit 1) and word (bits 2-3) bytes
-- bit 0 can be connected directly to !ce
Or 'ch'
wire '!ce/ch.a[0]'
wire '!half/ch.a[1]'
Or 'cw'
wire '!ce/cw.a[0]'
wire '!word/cw.a[1]'

-- align chip enable signals
-- rotate by 2 if a[1] is high
X74157 'ce1'
wire 'a[1]/ce1.s'
wire 'GND.q/ce1.!e'
wire '!ce/ce1.a[0]'
wire 'ch.q/ce1.a[1]'
fan 'cw.q/ce1.a[2-3]'
fan 'cw.q/ce1.b[0-1]'
wire '!ce/ce1.b[2]'
wire 'ch.q/ce1.b[3]'

-- then rotate by 1 more if a[0] is high
X74157 'ce2'
wire 'a[0]/ce2.s'
wire 'GND.q/ce2.!e'
wire 'ce1.q/ce2.a'
wire 'ce1.q[0-2]/ce2.b[1-3]'
wire 'ce1.q[3]/ce2.b[0]'
wire 'ce2.q[0]/m0.!ce'
wire 'ce2.q[1]/m1.!ce'
wire 'ce2.q[2]/m2.!ce'
wire 'ce2.q[3]/m3.!ce'

-----------------------------------------------------------
-- data direction signal
Or '!dir'
wire '!ce/!dir.a[0]'
wire '!w/!dir.a[1]'

--------------------------------------------------------------
---- alignment matrix row selector
And 'rsa'
wire '!oe/rsa.a[0]'
wire '!w/rsa.a[1]'
Or 'rso'
wire 'rsa.q/rso.a[0]'
wire '!ce/rso.a[1]'
X74139 'align'
wire 'align.!ea/rso.q'
wire 'align.!eb/VCC.q'
fan 'VCC.q/align.sb'
wire 'align.sa/a[0-1]'

--------------------------------------------------------------
-- alignment matrix
-- a % 4 == 0
-- connect banks 0-3 data to port a of next 4 components respectively
X74245 'b00'
wire 'align.!qa[0]/b00.!oe'
wire '!dir.q/b00.dir'
wire 'b00.a/m0.d'

X74245 'b01'
wire 'align.!qa[0]/b01.!oe'
wire '!dir.q/b01.dir'
wire 'b01.a/m1.d'

X74245 'b02'
wire 'align.!qa[0]/b02.!oe'
wire '!dir.q/b02.dir'
wire 'b02.a/m2.d'

X74245 'b03'
wire 'align.!qa[0]/b03.!oe'
wire '!dir.q/b03.dir'
wire 'b03.a/m3.d'

-- a % 4 == 1
X74245 'b10'
wire 'align.!qa[1]/b10.!oe'
wire '!dir.q/b10.dir'
wire 'b03.b/b10.b'
wire 'b00.a/b10.a'

X74245 'b11'
wire 'align.!qa[1]/b11.!oe'
wire '!dir.q/b11.dir'
wire 'b00.b/b11.b'
wire 'b01.a/b11.a'

X74245 'b12'
wire 'align.!qa[1]/b12.!oe'
wire '!dir.q/b12.dir'
wire 'b01.b/b12.b'
wire 'b02.a/b12.a'

X74245 'b13'
wire 'align.!qa[1]/b13.!oe'
wire '!dir.q/b13.dir'
wire 'b02.b/b13.b'
wire 'b03.a/b13.a'

-- a % 4 == 2
X74245 'b20'
wire 'align.!qa[2]/b20.!oe'
wire '!dir.q/b20.dir'
wire 'b13.b/b20.b'
wire 'b10.a/b20.a'

X74245 'b21'
wire 'align.!qa[2]/b21.!oe'
wire '!dir.q/b21.dir'
wire 'b10.b/b21.b'
wire 'b11.a/b21.a'

X74245 'b22'
wire 'align.!qa[2]/b22.!oe'
wire '!dir.q/b22.dir'
wire 'b11.b/b22.b'
wire 'b12.a/b22.a'

X74245 'b23'
wire 'align.!qa[2]/b23.!oe'
wire '!dir.q/b23.dir'
wire 'b12.b/b23.b'
wire 'b13.a/b23.a'

-- a % 4 == 3
X74245 'b30'
wire 'align.!qa[3]/b30.!oe'
wire '!dir.q/b30.dir'
wire 'b23.b/b30.b'
wire 'b20.a/b30.a'

X74245 'b31'
wire 'align.!qa[3]/b31.!oe'
wire '!dir.q/b31.dir'
wire 'b20.b/b31.b'
wire 'b21.a/b31.a'

X74245 'b32'
wire 'align.!qa[3]/b32.!oe'
wire '!dir.q/b32.dir'
wire 'b21.b/b32.b'
wire 'b22.a/b32.a'

X74245 'b33'
wire 'align.!qa[3]/b33.!oe'
wire '!dir.q/b33.dir'
wire 'b22.b/b33.b'
wire 'b23.a/b33.a'

-----------------------------------------------------------
-- output with sign extension
And 'sbb'
wire 'sbb.a[0]/signed'
wire 'sbb.a[1]/b00.b[7]'
X74157 { 'mb', width = 8 }
wire 'GND.q/mb.!e'
wire '!half/mb.s'
fan 'sbb.q/mb.b'
wire 'b01.b/mb.a'

And 'scb'
wire 'scb.a[0]/signed'
wire 'scb.a[1]/mb.q[7]'
X74157 { 'mc', width = 16 }
wire 'GND.q/mc.!e'
wire '!word/mc.s'
fan 'scb.q/mc.b'
wire 'b02.b/mc.a[0-7]'
wire 'b03.b/mc.a[8-15]'

Not 'w'
wire '!w/w.a'
Or { 'out_oe', width = 3 }
wire '!ce/out_oe.a[0]'
wire '!oe/out_oe.a[1]'
wire 'w.q/out_oe.a[2]'
X74245 { 'out', width = 32 }
wire 'VCC.q/out.dir'
wire 'out_oe.q/out.!oe'
wire 'out.b/d'
wire 'out.a[0-7]/b00.b'
wire 'out.a[8-15]/mb.q'
wire 'out.a[16-31]/mc.q'

-----------------------------------------------------------
-- input
X74245 { 'in', width = 32 }
wire '!dir.q/in.!oe'
wire 'GND.q/in.dir'
BufferBank { 'obuf', width = 32, depth = 1 }
wire 'obuf.a/d'
wire 'in.b/obuf.q'
wire 'b00.b/in.a[0-7]'
wire 'b01.b/in.a[8-15]'
wire 'b02.b/in.a[16-23]'
wire 'b03.b/in.a[24-31]'
