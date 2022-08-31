local trace = opts.trace and true or false

output('a', 31, trace)
Pulldown { 'a', width = 32 }
wire 'a.q/a'

output('b', 31, trace)
Pulldown { 'b', width = 32 }
wire 'b.q/b'

output('d', 31, trace)
Pulldown { 'd', width = 32 }
--wire 'd.q/d'

output('address', 31, trace)
Pulldown { 'address', width = 32 }
wire 'address.q/address'

output('instruction', 31, trace)
Pulldown { 'instruction', width = 32 }
wire 'instruction.q/instruction'
