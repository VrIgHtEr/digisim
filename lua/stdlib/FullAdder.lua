input 'a'
input 'b'
input 'cin'
output 's'
output 'c'

Xor 'x1'
wire 'a/x1.a[0]'
wire 'b/x1.a[1]'

Xor 'x2'
wire 'x1.q/x2.a[0]'
wire 'cin/x2.a[1]'
wire 'x2.q/s'

And 'a1'
wire 'x1.q/a1.a[0]'
wire 'cin/a1.a[1]'

And 'a2'
wire 'a/a2.a[0]'
wire 'b/a2.a[1]'

Or 'o'
wire 'a1.q/o.a[0]'
wire 'a2.q/o.a[1]'
wire 'o.q/c'
