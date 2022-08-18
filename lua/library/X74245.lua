local w = math.floor(opts.width or 8)
if w < 1 then
    error 'width < 1'
end

output('a', w - 1)
output('b', w - 1)
input 'dir'
input '!oe'

Not 'oe'
wire '!oe/oe.a'

Not '!dir'
wire 'dir/!dir.a'

And 'na'
wire 'oe.q/na.a[0]'
wire 'dir/na.a[1]'
And 'nb'
wire 'oe.q/nb.a[0]'
wire '!dir.q/nb.a[1]'

TristateBufferBank { 'a', width = w }
wire 'a/a.a'
wire 'na.q/a.en'
wire 'a.q/b'

TristateBufferBank { 'b', width = w }
wire 'b/b.a'
wire 'nb.q/b.en'
wire 'b.q/a'
