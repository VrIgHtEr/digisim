local digisim = _G['digisim']
local digisim_path = _G['digisim_path']
local project_path = _G['project_path']

local search_paths = { project_path, digisim_path .. '/stdlib' }

---@param file string
---@return string|nil
local function read_file(file)
    local osuccess, f = pcall(io.open, file, 'rb')
    if not osuccess or not f then
        return
    end
    local success, content = pcall(f.read, f, '*all')
    if not success or not content then
        return
    end
    f:close()
    return content
end

local function search_read_file(file)
    for _, x in ipairs(search_paths) do
        local f = read_file(x .. '/' .. file)
        if f then
            return f
        end
    end
end

local function mem(file)
    local c = read_file(project_path .. '/' .. file) or ''
    local ret = {}
    for i = 1, string.len(c) do
        ret[i] = string.byte(string.sub(c, i, i))
    end
    return ret
end

local function dbg(str)
    io.stderr:write(str)
    io.stderr:write '\n'
    io.stderr:flush()
end

local base_env = {
    math = math,
    table = table,
    pairs = pairs,
    ipairs = ipairs,
    tostring = tostring,
    type = type,
    error = error,
    debug = dbg,
    bit = bit,
    mem = mem,
    string = setmetatable({}, {
        __index = string,
        __newindex = function()
            error 'cannot write to string table'
        end,
    }),
}

local cache = {}

local function validate_createport_inputs(name, pin_end, trace)
    if type(name) ~= 'string' then
        error 'invalid name'
    end
    if pin_end == nil then
        if trace == nil then
            trace = false
        elseif type(trace) ~= 'boolean' then
            error 'invalid trace value'
        end
        pin_end = 0
    elseif trace == nil then
        if type(pin_end) == 'boolean' then
            trace = pin_end
            pin_end = 0
        else
            trace = false
        end
    end
    if type(pin_end) ~= 'number' then
        error 'invalid pin_end'
    end
    if pin_end < 0 or pin_end >= 1048576 then
        error 'pin index out of bounds'
    end
    return name, pin_end, trace
end

local function validate_component_inputs(name, opts)
    if opts == nil then
        if type(name) == 'table' then
            opts = name
            name = opts.name
            if name == nil then
                name = opts[1]
            end
        else
            opts = {}
        end
    end
    if type(opts) ~= 'table' then
        error 'invalid opts'
    end
    if type(name) ~= 'string' then
        error 'invalid name'
    end
    opts.name = name
    return name, opts
end

local function validate_builtin_component_inputs(name, opts, def_pin_end)
    name, opts = validate_component_inputs(name, opts)
    local pin_end
    if opts.width then
        pin_end = opts.width - 1
    else
        pin_end = def_pin_end or 0
    end
    opts.width = pin_end + 1
    return name, pin_end
end

local function validate_wire_inputs(a, b)
    if b == nil then
        if type(a) == 'string' then
            local index = 1
            for i = 1, a:len() do
                if a:sub(i, i) == '/' then
                    break
                end
                index = index + 1
            end
            if index >= a:len() then
                error 'invalid wire b endpoint'
            end
            if index == 1 then
                error 'invalid wire a endpoint'
            end
            b = a:sub(index + 1)
            a = a:sub(1, index - 1)
        end
    end
    return a, b
end

local sig = { uninitialized = 0, unknown = 1, low = 2, high = 3, z = 4, weak = 5, weaklow = 6, weakhigh = 7 }

local function create_env(id, opts)
    return setmetatable({}, {
        __index = setmetatable({
            sig = sig,
            opts = opts,
            input = function(name, pin_end, trace)
                name, pin_end, trace = validate_createport_inputs(name, pin_end, trace)
                digisim.createport(id, name, true, 0, math.floor(pin_end), trace)
            end,
            output = function(name, pin_end, trace)
                name, pin_end, trace = validate_createport_inputs(name, pin_end, trace)
                digisim.createport(id, name, false, 0, math.floor(pin_end), trace)
            end,
            wire = function(a, b)
                digisim.connect(id, validate_wire_inputs(a, b))
            end,
            fan = function(a, b)
                digisim.fan(id, validate_wire_inputs(a, b))
            end,
            cheat = function(func)
                digisim.cheat(id, func)
            end,
            Not = function(name, o)
                digisim.components.Not(id, validate_builtin_component_inputs(name, o, 0))
            end,
            Nand = function(name, o)
                digisim.components.Nand(id, validate_builtin_component_inputs(name, o, 1))
            end,
            And = function(name, o)
                digisim.components.And(id, validate_builtin_component_inputs(name, o, 1))
            end,
            Nor = function(name, o)
                digisim.components.Nor(id, validate_builtin_component_inputs(name, o, 1))
            end,
            Or = function(name, o)
                digisim.components.Or(id, validate_builtin_component_inputs(name, o, 1))
            end,
            Xor = function(name, o)
                digisim.components.Xor(id, validate_builtin_component_inputs(name, o, 1))
            end,
            Xnor = function(name, o)
                digisim.components.Xnor(id, validate_builtin_component_inputs(name, o, 1))
            end,
            Pullup = function(name, o)
                digisim.components.Pullup(id, validate_builtin_component_inputs(name, o))
            end,
            Pulldown = function(name, o)
                digisim.components.Pulldown(id, validate_builtin_component_inputs(name, o))
            end,
            Buffer = function(name, o)
                digisim.components.Buffer(id, validate_builtin_component_inputs(name, o))
            end,
            TristateBuffer = function(name, o)
                digisim.components.TristateBuffer(id, validate_builtin_component_inputs(name, o))
            end,
            Reset = function(name, o)
                name, o = validate_component_inputs(name, o)
                digisim.components.Reset(id, name, o.period == nil and 1 or o.period)
            end,
            Clock = function(name, o)
                name, o = validate_component_inputs(name, o)
                digisim.components.Clock(id, name, o.period == nil and 1 or o.period)
            end,
            High = function(name, o)
                digisim.components.High(id, validate_component_inputs(name, o))
            end,
            Low = function(name, o)
                digisim.components.Low(id, validate_component_inputs(name, o))
            end,
        }, {
            __newindex = function()
                error 'writing to global variables is not allowed'
            end,
            __metatable = function() end,
            __index = function(_, index)
                if type(index) == 'string' and index:len() > 0 then
                    local c = index:sub(1, 1):byte()
                    if c >= ('A'):byte() and c <= ('Z'):byte() then
                        local constructor
                        if cache[index] ~= nil then
                            if not cache[index] then
                                return
                            end
                            constructor = cache[index]
                        else
                            local file = search_read_file(index .. '.lua')
                            if file then
                                local success, compiled = pcall(loadstring, file, index)
                                if not success or not compiled then
                                    cache[index] = false
                                    error('syntax error in component definition file: ' .. index .. ': ' .. tostring(compiled))
                                    return
                                end
                                constructor = compiled
                                cache[index] = constructor
                            else
                                error('Component definition file not found: ' .. index)
                            end
                        end
                        return function(name, o)
                            name, o = validate_component_inputs(name, o)
                            local comp = digisim.createcomponent(id, name)
                            local old_fenv = getfenv(constructor)
                            setfenv(constructor, create_env(comp, o))
                            local success, err = pcall(constructor)
                            setfenv(constructor, old_fenv)
                            if not success then
                                error(err)
                            end
                        end
                    end
                end
                return base_env[index]
            end,
        }),
    })
end

local function compile(opts)
    local stderr = io.stderr
    local text = search_read_file 'root.lua'
    if text == nil then
        error 'failed to load root component'
    end
    local constructor = loadstring(text)
    if constructor == nil then
        error 'failed to load root component'
    end
    if opts == nil then
        opts = {}
    end
    if type(opts) ~= 'table' then
        error 'invalid opts'
    end
    opts.name = '.'
    local old_env = getfenv(constructor)
    setfenv(constructor, create_env(digisim.root, opts))
    local ret = { pcall(constructor) }
    setfenv(constructor, old_env)
    if ret[1] then
        table.remove(ret, 1)
        return unpack(ret)
    else
        stderr:write('LUA ERROR: ' .. tostring(ret[2]) .. '\n')
        error(ret[2])
    end
end

compile()
