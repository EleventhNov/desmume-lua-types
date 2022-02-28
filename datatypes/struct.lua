Struct = {}
function Struct:new(decl)
    local read = function(address) return read_struct(address, decl) end
    local size = calculate_struct_size(decl)
    local string = function() return struct_to_string(decl) end
    local object = DataType:new(read, nil, nil, string, size) -- TODO: Add write struct method!
    object.decl = decl
    setmetatable(object, self)
    self.__index = self
    return object
end

function Struct:at(address)
    unit = DataUnit:new(self, address)
    for name,field in pairs(self.decl) do
        offset = field[1]
        type = field[2]
        unit[name] = type:at(address + offset)
    end

    unit.print = function() print(self.string()) end
    return unit
end

function read_struct(address, decl)
    result = {}
    for name,field in pairs(decl) do
        offset = field[1]
        type = field[2]
        result[name] = type:read(address + offset)
    end return result
end

function calculate_struct_size(decl)
    total = 0
    for name,field in pairs(decl) do
        total = total + field[2].size
    end
    return total
end

function struct_to_string(decl)
    fields = {}
    idx = 1
    for name,field in pairs(decl) do
        fields[idx] = string.format("%s: %s", name, unit[name]:string())
        idx = idx + 1
    end
    return '{'..table.concat(fields, ", ")..'}'
end