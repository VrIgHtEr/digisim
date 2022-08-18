local trace = opts.trace and true or false

output('a', 31, trace)
output('b', 31, trace)
output('d', 31, trace)

Pulldown { 'a', width = 32 }
wire 'a.q/a'
Pulldown { 'b', width = 32 }
wire 'b.q/b'
Pulldown { 'd', width = 32 }
wire 'd.q/d'
