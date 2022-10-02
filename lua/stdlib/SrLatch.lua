local trace = opts.trace and true or false
input('!s', trace)
input('!r', trace)

output('q', trace)
output('!q', trace)

Nand 'a'
wire '!s/a.a[1]'
Nand 'b'
wire '!r/b.a[1]'
wire 'a.q/b.a[0]'
wire 'b.q/a.a[0]'
wire 'a.q/q'
wire 'b.q/!q'
