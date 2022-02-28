require "datatypes/unit"

DataType = {}
function DataType:new(read, write, from_reg, size)
    local object = {read=read, write=write, from_reg=from_reg, size=size}
    setmetatable(object, self)
    self.__index = self
    return object
end

function DataType:at(addr)
    return DataUnit:new(self, addr)
end

function DataType:from_register(value)
    return self.from_reg(value)
end