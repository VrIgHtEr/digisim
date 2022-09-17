input '!e'
input('a', 4)
output('y', 31)

X74154 'lo'
wire '!e/lo.!e0'
wire 'a[4]/lo.!e1'
wire 'a[0-3]/lo.a'
wire 'lo.y/y[0-15]'

X7404 { '!yt', width = 1 }
wire 'a[4]/!yt.a'
X74154 'hi'
wire '!e/hi.!e0'
wire '!yt.q/hi.!e1'
wire 'a[0-3]/hi.a'
wire 'hi.y/y[16-31]'
