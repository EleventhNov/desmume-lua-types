require "datatypes/int"

Pointer = datatype_int(4, false)
function Pointer:new(type)
    local read = function(address) 
        if type == nil then
            return Pointer.read(address)
        end return type.read(address) 
    end
    local from_reg = function(value) return type:at(value) end
    local string = function(pointer) return string.format("%x", pointer:get()) end
    local object = {type=type, read=read, from_reg=from_reg, string=string}
    setmetatable(object, self)
    self.__index = self
    return object
end


function ptr(datatype)
    return Pointer:new(datatype)
end