require "datatypes/unit"

DataType = {}
function DataType:new(read, write, size)
    local object = {read=read, write=write, size=size}
    setmetatable(object, self)
    self.__index = self
    return object
end

function DataType:at(addr)
    return DataUnit:new(self, addr)
end