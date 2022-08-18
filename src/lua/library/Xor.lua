input('a', 1)
output 'q'

Nand 'a'
wire 'a[0]/a.a[0]'
wire 'a[1]/a.a[1]'

Nand 'b'
wire 'a[0]/b.a[0]'
wire 'a.q/b.a[1]'

Nand 'c'
wire 'a.q/c.a[0]'
wire 'a[1]/c.a[1]'

Nand 'd'
wire 'b.q/d.a[0]'
wire 'c.q/d.a[1]'

wire 'd.q/q'
