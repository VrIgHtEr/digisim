local trace = opts.trace and true or false

output('!mem_oe', trace)
Pullup '!mem_oe'
wire '!mem_oe.q/!mem_oe'

output('!mem_ce', trace)
Pullup '!mem_ce'
wire '!mem_ce.q/!mem_ce'

output('!mem_we', trace)
Pullup '!mem_we'
wire '!mem_we.q/!mem_we'

output('!mem_word', trace)
Pullup '!mem_word'
wire '!mem_word.q/!mem_word'

output('!mem_half', trace)
Pullup '!mem_half'
wire '!mem_half.q/!mem_half'

output('mem_signed', trace)
Pulldown 'mem_signed'
wire 'mem_signed.q/mem_signed'
