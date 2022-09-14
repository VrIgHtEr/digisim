local memory = opts.memory or {}
if type(memory) ~= 'table' then
    error 'invalid memory'
end
for k, v in pairs(memory) do
    if type(k) ~= 'number' or k < 1 or k >= 2097153 or k % 1 ~= 0 or type(v) ~= 'number' or v < 0 or v >= 256 then
        error 'invalid memory'
    end
end

debug('    DUMP: ' .. name)
for k, v in ipairs(memory) do
    debug('        ' .. k .. ': ' .. bit.tobit(math.floor(v)))
end

local function extract(size, offset)
    local ret = {}
    for k, v in pairs(memory) do
        local k1 = k - 1
        if k1 % size == offset then
            ret[math.floor(k1 / size) + 1] = math.floor(v)
        end
    end
    return ret
end

input '!ce'
input '!oe'
input '!we'
input('a', 29)
output('d', 7)

X74139 'csm'
wire 'GND/csm.!ea'
wire 'a[0-1]/csm.sa'
wire 'VCC/csm.!eb'
fan 'VCC/csm.sb'

X7432 { 'cso', width = 4 }
fan '!ce/cso.a'
wire 'csm.!qa/cso.b'

Sram { 'm0', memory = extract(4, 0) }
wire '!oe/m0.!oe'
wire '!we/m0.!we'
wire 'cso.q[0]/m0.!ce'
wire 'a[2-20]/m0.a'
wire 'd/m0.d'

Sram { 'm1', memory = extract(4, 1) }
wire '!oe/m1.!oe'
wire '!we/m1.!we'
wire 'cso.q[1]/m1.!ce'
wire 'a[2-20]/m1.a'
wire 'd/m1.d'

Sram { 'm2', memory = extract(4, 2) }
wire '!oe/m2.!oe'
wire '!we/m2.!we'
wire 'cso.q[2]/m2.!ce'
wire 'a[2-20]/m2.a'
wire 'd/m2.d'

Sram { 'm3', memory = extract(4, 3) }
wire '!oe/m3.!oe'
wire '!we/m3.!we'
wire 'cso.q[3]/m3.!ce'
wire 'a[2-20]/m3.a'
wire 'd/m3.d'
