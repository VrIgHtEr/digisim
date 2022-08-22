input('d', 31)
input 'w'
input 'cp'
input '!mr'
output('a', 31)

X74273 { 'r', width = 32 }
wire '!mr/r.!mr'
wire 'd/r.d'
wire 'a/r.q'

And 'clk'
wire 'cp/clk.a[0]'
wire 'w/clk.a[1]'
wire 'clk.q/r.cp'
