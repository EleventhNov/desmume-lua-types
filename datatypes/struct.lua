Struct = {}
function Struct:new(decl)
    local read = function(address) return read_struct(address, decl) end
    local size = calculate_struct_size(decl)
    local object = DataType:new(read, nil, nil, size) -- TODO: Add write struct method!
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

    unit.print = function()
        for name,field in pairs(self.decl) do
            printf("%s = %s", name, unit[name]:get())
        end
    end

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
    end return total
end