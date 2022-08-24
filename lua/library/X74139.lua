local w = opts.width or 2
if type(w) ~= 'number' then
    error 'invalid width type'
end
w = math.floor(w)
if w < 1 then
    error 'invalid width'
end
local o = math.pow(2, w)

input('sa', w - 1)
input('sb', w - 1)
input '!ea'
input '!eb'
output('!qa', o - 1)
output('!qb', o - 1)

BinaryDecoder { 'a', width = w }
wire 'sa/a.a'
X7404 { 'na', width = o }
wire 'a.q/na.a'
X7432 { 'oa', width = o }
wire 'na.q/oa.a'
wire 'oa.q/!qa'
for i = 0, o - 1 do
    wire('!ea/oa.b[' .. i .. ']')
end

BinaryDecoder { 'b', width = w }
wire 'sb/b.a'
X7404 { 'nb', width = o }
wire 'b.q/nb.a'
X7432 { 'ob', width = o }
wire 'nb.q/ob.a'
wire 'ob.q/!qb'
for i = 0, o - 1 do
    wire('!eb/ob.b[' .. i .. ']')
end
